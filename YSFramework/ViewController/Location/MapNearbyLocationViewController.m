//
//  MapNearbyLocationViewController.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/10.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "MapNearbyLocationViewController.h"
#import "BaseConst.h"
#import "UIView+YSLayout.h"
#import "NSString+YSCheck.h"
#import "MJRefresh.h"
#import "SelectLocationCell.h"

@interface MapNearbyLocationViewController ()<UITableViewDataSource,UITableViewDelegate,AMapSearchDelegate,MAMapViewDelegate,AMapLocationManagerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    // 第一次定位标记
    BOOL isFirstLocated;
    // 禁止连续点击两次
    BOOL _isMapViewRegionChangedFromTableView;
    BOOL isFirstEnter;
    BOOL isSearchShow;
    
    AMapPOI *_selectedPoi;
    // 搜索页数
    NSInteger searchPage;
    //headview 搜索栏
    UIView *headView;
    
    UIButton *followBtn;
    UIImageView *centerMaker; // 中心点坐标
    
    // Poi搜索结果数组
    NSMutableArray *_poiArray;
    NSMutableArray *_searchPoiArray;
    
    // 选中的IndexPath
    NSIndexPath *_selectedIndexPath;
    NSString *locatingCity; //定位得到城市
    
    // 下拉更多请求数据的标记
    BOOL isFromMoreLoadRequest;
    
    // 搜索key
    NSString *_searchString;
    
    MAAnnotationView *locationAnnotationView;
}
/**
 *  搜索框绑定的控制器
 */
@property (nonatomic) UISearchDisplayController *searchController;

@property (nonatomic,strong) AMapSearchAPI  *searchAPI;
@end

@implementation MapNearbyLocationViewController


#pragma mark 将颜色转换成图片
-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (UISearchBar *)aSearchBar {
    if (!_aSearchBar) {
        _aSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, YS_SCREEN_WIDTH, 44)];
        if (STATUS_BAR_BIGGER_THAN_20 && !YS_IPHONEX) {
            _aSearchBar.y = -20;
        }
//        _aSearchBar.placeholder = LZGDCommonLocailzableString(@"common_search");
        _aSearchBar.delegate = self;
        _aSearchBar.backgroundImage=[self createImageWithColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0]];
    }
    return _aSearchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_mapLocationStyle == MapLocationStyleDefault){
        self.title = [NSString isNullOrEmpty:_navTitle] ? @"选择位置" : _navTitle;
    }
    else{
        self.title = [NSString isNullOrEmpty:_navTitle] ? @"定位签到" : _navTitle;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(SureAction)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    if(_finescope==0)_finescope = 1000;//默认半径1000
    //初始页数
    searchPage = 1;
    // 初始化时保证_searchPoiArray长度为1
    _poiArray = [NSMutableArray array];
    _searchPoiArray = [NSMutableArray array];
    if(_mapLocationStyle != MapLocationStyleSelectSinglePOI){
        AMapPOI *point = [[AMapPOI alloc] init];
        [_poiArray addObject:point];
    }
    [self initMapView];
    [self initBaseView];
    [self initLocationButton];
    /* 定位权限判断，开启定位 */
    [self locationPermissions];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_aSearchBar becomeFirstResponder];
    [self.navigationController.view addSubview: headView];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
    
    [headView removeFromSuperview];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0.918 alpha:1.000]];
    
}
/**
 *  控制器销毁的时候删除数组中的元素
 */
- (void)dealloc {
}
#pragma mark - 初始化
//地图初始化
- (void)initMapView
{
    self.mapView = [[MAMapView alloc] init];
    self.mapView.frame=CGRectMake(0, YS_STATUS_NAV_HEIGHT+self.aSearchBar.frame.size.height, YS_SCREEN_WIDTH, YS_SCREEN_HEIGHT/2-40);
    if (STATUS_BAR_BIGGER_THAN_20 && !YS_IPHONEX) {
        self.mapView.y = YS_STATUS_NAV_HEIGHT+self.aSearchBar.frame.size.height-20;
    }
    // 地图缩放等级
    self.mapView.zoomLevel=17.5;
    self.mapView.delegate = self;
    // 不显示罗盘
    self.mapView.showsCompass=NO;
    CGPoint oldCenter = self.mapView.logoCenter;
    //    self.mapView.logoCenter = CGPointMake(self.mapView.bounds.size.width - oldCenter.x, oldCenter.y);//高德logo
    self.mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    self.mapView.scaleOrigin= CGPointMake(5, oldCenter.y-25);  //设置比例尺位置
    [self.view addSubview:self.mapView];
    //中心点
    UIImage *image = [UIImage imageNamed:@"AMap.bundle/images/redPin"];
    centerMaker = [[UIImageView alloc] initWithImage:image];
    centerMaker.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    centerMaker.center = CGPointMake(self.mapView.bounds.size.width/2,self.mapView.bounds.size.height/2);
    [self.mapView addSubview:centerMaker];
    centerMaker.hidden = YES;
    if(_mapLocationStyle == MapLocationStyleSelectSingle){
        self.mapView.frame=CGRectMake(0, YS_STATUS_NAV_HEIGHT, YS_SCREEN_WIDTH, YS_SCREEN_HEIGHT/2-20);
    }
    if(_mapLocationStyle == MapLocationStyleDefault) centerMaker.hidden = NO;
}

//跟随按钮
- (void)initLocationButton
{
    followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    followBtn.frame = CGRectMake(self.mapView.bounds.size.width - self.mapView.logoCenter.x-20, self.mapView.frame.size.height+self.mapView.frame.origin.y-60, 44, 44);
    [followBtn setBackgroundImage:[UIImage imageNamed:@"AMap.bundle/sign_target"] forState:UIControlStateNormal];
    [followBtn addTarget:self action:@selector(followMark) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:followBtn];
}

//控件初始化
-(void)initBaseView{
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
    
    //tableviwe
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = CGRectMake(0, self.mapView.frame.origin.y+self.mapView.frame.size.height, YS_SCREEN_WIDTH, self.view.frame.size.height-(self.mapView.frame.origin.y+self.mapView.frame.size.height));
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight=0;
    self.tableView.sectionHeaderHeight=0;

    self.tableView.backgroundColor = [UIColor whiteColor];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.view addSubview:self.tableView];
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, YS_STATUS_NAV_HEIGHT, YS_SCREEN_WIDTH, 44)];
    [headView addSubview:self.aSearchBar];
    //搜索栏
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_aSearchBar contentsController:self];
    _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; //隐藏多于的分隔线
    _searchController.delegate = self;
    _searchController.searchResultsDelegate = self;
    _searchController.searchResultsDataSource = self;
    if (@available(iOS 11.0, *)) {
        _searchController.searchResultsTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //        _searchController.searchContentsController.additionalSafeAreaInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        
    }
    /* 上拉加载 */
    self.searchDisplayController.searchResultsTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(searchLoadMoreData)];
    if(_mapLocationStyle == MapLocationStyleSelectSingle){
        self.tableView.frame =CGRectMake(0, self.mapView.frame.origin.y+self.mapView.frame.size.height, YS_SCREEN_WIDTH, YS_SCREEN_HEIGHT-(self.mapView.frame.origin.y+self.mapView.frame.size.height));
        headView.hidden = YES;
        _aSearchBar.hidden = YES;
        _tableView.mj_footer.hidden = YES;
    }
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    // 首次定位
    if (updatingLocation && !isFirstLocated) {
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
        if(_mapLocationStyle == MapLocationStyleSelectSingle){
            [self searchReGeocodeWithAMapGeoPoint:point];
        }
        else if (_mapLocationStyle == MapLocationStyleSelectSinglePOI){
            // 范围移动时当前页面数重置
            searchPage = 1;
            [self searchPoiByAMapGeoPoint:point];
        }
        isFirstLocated = YES;
        isFirstEnter= YES;
    }
}

/*!
 @brief 地图区域改变完成后会调用此接口
 @param mapView 地图View
 @param animated 是否动画
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if(_mapLocationStyle == MapLocationStyleDefault){
        if (!_isMapViewRegionChangedFromTableView && isFirstLocated) {
            AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
            [self searchReGeocodeWithAMapGeoPoint:point];
            [self searchPoiByAMapGeoPoint:point];
            // 范围移动时当前页面数重置
            searchPage = 1;
            if(!isFirstEnter){
                [self animationShootOut:centerMaker];
            }
        }
    }
    
    _isMapViewRegionChangedFromTableView = NO;
    isFirstEnter = NO;
}

/*!
 @brief 当mapView新添加annotation views时调用此接口
 @param mapView 地图View
 @param views 新添加的annotation views
 */
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    view.highlighted=YES;
    view.enabled=NO;
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.showsAccuracyRing = NO;
        
        if(_mapLocationStyle == MapLocationStyleDefault){
            pre.showsAccuracyRing=YES;
        }
        [self.mapView updateUserLocationRepresentation:pre];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    // 自定义userLocation对应的annotationView
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        if(_mapLocationStyle != MapLocationStyleDefault){
            static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
            locationAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
            if (locationAnnotationView == nil)
            {
                locationAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                         reuseIdentifier:userLocationStyleReuseIndetifier];
            }
            
            locationAnnotationView.image = [UIImage imageNamed:@"AMap.bundle/icon_location.png"];
            
            return locationAnnotationView;
        }
    }
    return nil;
    
}

// 搜索中心点坐标周围的POI-AMapGeoPoint
- (void)searchPoiByAMapGeoPoint:(AMapGeoPoint *)location
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    //    request.types = @"商务住宅|地名地址信息|公司企业|住宿服务|风景名胜|交通设施服务|道路附属设施|公共设施|餐饮服务|购物服务|生活服务|医疗保健服务|体育休闲服务|政府机构及社会团体|科教文化服务|金融保险服务|汽车销售";
    request.location = location;
    // 搜索半径
    request.radius = _finescope;
    // 搜索结果排序
    request.sortrule = 1;
    // 当前页数
    request.page = searchPage;
    request.requireExtension = YES;
    [_searchAPI AMapPOIAroundSearch:request];
}

// 搜索逆向地理编码-AMapGeoPoint
- (void)searchReGeocodeWithAMapGeoPoint:(AMapGeoPoint *)location
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = location;
    // 返回扩展信息
    regeo.requireExtension = YES;
    [_searchAPI AMapReGoecodeSearch:regeo];
}

- (void)searchPoiBySearchString:(NSString *)searchString
{
    //POI关键字搜索
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.sortrule = 1;
    request.requireExtension = YES;
    request.keywords = searchString;
    request.city = locatingCity;
    request.page = searchPage;
    request.requireSubPOIs = YES;
    [_searchAPI AMapPOIKeywordsSearch:request];
    
}

-(void)searchSelectSinglePoiBySearchString:(NSString *)searchString{
    AMapPOIAroundSearchRequest *searchRequest = [[AMapPOIAroundSearchRequest alloc]init];
    //关键字
    searchRequest.keywords = searchString;
    searchRequest.location                    = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
    searchRequest.sortrule                    = 1;
    searchRequest.requireExtension            = YES;
    searchRequest.page                        = searchPage;
    searchRequest.radius                      = _finescope;
    searchRequest.requireSubPOIs      = YES;
    [_searchAPI AMapPOIAroundSearch:searchRequest];
}

#pragma mark - AMapSearchDelegate
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil) {
        // 去掉逆地理编码结果的省份和城市
        NSString *address = response.regeocode.formattedAddress;
        AMapAddressComponent *component = response.regeocode.addressComponent;
        address = [address stringByReplacingOccurrencesOfString:component.province withString:@""];
        address = [address stringByReplacingOccurrencesOfString:component.city withString:@""];
        // 将逆地理编码结果保存到数组第一个位置，并作为选中的POI点
        _selectedPoi = [[AMapPOI alloc] init];
        _selectedPoi.name = address;
        _selectedPoi.address = response.regeocode.formattedAddress;
        _selectedPoi.location = request.location;
        [_poiArray setObject:_selectedPoi atIndexedSubscript:0];
        // 刷新TableView第一行数据
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        NSLog(@"_selectedPoi.name:%@",_selectedPoi.name);
        //        // 刷新后TableView返回顶部
        //        if (@available(iOS 11.0, *)) {
        [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        //        }
        //        else{
        //             [_tableView setContentOffset:CGPointMake(0, -64) animated:NO];
        //        }
        
        locatingCity = response.regeocode.addressComponent.province;
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if ([request isKindOfClass:[AMapPOIKeywordsSearchRequest class]]){
        if(isSearchShow){
            isSearchShow = NO;
            // 刷新POI后默认第一行为打勾状态
            _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            if(response.pois.count == 0){
                _tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            else {
                _tableView.mj_footer.state = MJRefreshStateIdle;
            }
            // 添加数据并刷新TableView
            [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
                [_poiArray addObject:obj];
            }];
            [_tableView reloadData];
            return;
        }
        // 刷新完成,没有数据时不显示footer
        if (response.pois.count == 0) {
            self.searchDisplayController.searchResultsTableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        else {
            self.searchDisplayController.searchResultsTableView.mj_footer.state = MJRefreshStateIdle;
        }
        
        // 添加数据并刷新TableView
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
            [_searchPoiArray addObject:obj];
        }];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
    else{
        if (request.requireSubPOIs){
            // 刷新完成,没有数据时不显示footer
            if (response.pois.count == 0) {
                self.searchDisplayController.searchResultsTableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            else {
                self.searchDisplayController.searchResultsTableView.mj_footer.state = MJRefreshStateIdle;
            }
            
            // 添加数据并刷新TableView
            [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
                [_searchPoiArray addObject:obj];
            }];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }else{
            // 刷新POI后默认第一行为打勾状态
            _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            // 判断搜索结果是否来自于下拉刷新
            if (isFromMoreLoadRequest) {
                isFromMoreLoadRequest = NO;
            }
            else{
                //保留数组第一行数据
                if (_poiArray.count > 1) {
                    [_poiArray removeObjectsInRange:NSMakeRange(1, _poiArray.count-1)];
                }
            }
            
            // 刷新完成,没有数据时不显示footer
            if (response.pois.count == 0) {
                _tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            else {
                _tableView.mj_footer.state = MJRefreshStateIdle;
            }
            
            // 添加数据并刷新TableView
            [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
                [_poiArray addObject:obj];
            }];
            [_tableView reloadData];
        }
    }
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

#pragma mark TableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        return _searchPoiArray.count;
    }
    return _poiArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"SelectLocationCell";
    SelectLocationCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        
        cell=[[SelectLocationCell alloc]initWithMapStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        
        AMapPOI *info = _searchPoiArray[indexPath.row];
        cell.textLabel.text         = info.name.length > 0 ? info.name : info.city;
        cell.detailTextLabel.text   = info.address;
        cell.accessoryType  = UITableViewCellAccessoryNone;
        
        return cell;
    }
    else{
        AMapPOI *info               = _poiArray[indexPath.row];
        
        if (indexPath.row == 0 && _mapLocationStyle == MapLocationStyleDefault) {
            cell.textLabel.text         = @"[位置]";
        }
        else{
            cell.textLabel.text         = info.name.length > 0 ? info.name : info.city;
        }
        cell.detailTextLabel.text   = info.name.length > 0 ? [NSString stringWithFormat:@"%@%@%@",info.city,info.district,info.address] : @"未知位置";
        cell.accessoryType  = UITableViewCellAccessoryNone;
        
        if (indexPath.row==_selectedIndexPath.row) {
            cell.accessoryType      = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType  = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        if (_poiArray.count > 1) {
            [_poiArray removeObjectsInRange:NSMakeRange(1, _poiArray.count-1)];
        }
        _selectedPoi = _searchPoiArray[indexPath.row];
        [_poiArray setObject:_selectedPoi atIndexedSubscript:0];
        AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_selectedPoi.location.latitude longitude:_selectedPoi.location.longitude];
        if(_mapLocationStyle == MapLocationStyleDefault){
            isSearchShow = YES;
            [self searchReGeocodeWithAMapGeoPoint:point];
            [self searchPoiBySearchString:_searchString];
        }
        else if(_mapLocationStyle == MapLocationStyleSelectSinglePOI){
            _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        [_tableView reloadData];
        self.searchController.active = NO;
        
    }else{
        _selectedPoi = _poiArray[indexPath.row];
    }
    NSInteger newRow = indexPath.row;
    NSInteger oldRow = _selectedIndexPath != nil ? _selectedIndexPath.row : -1;
    if (newRow != oldRow) {
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        if(_mapLocationStyle == MapLocationStyleSelectSinglePOI){
            _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
    }
    else{
        _selectedIndexPath = indexPath;
    }
    _isMapViewRegionChangedFromTableView = YES;
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(_selectedPoi.location.latitude,_selectedPoi.location.longitude);
    locationAnnotationView.annotation.coordinate = centerCoordinate;
    /* 地图跟随移动 */
    [_mapView setCenterCoordinate:centerCoordinate animated:YES];
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        //取消搜索状态
        [self.searchDisplayController setActive:NO animated:YES];
    }
}

#pragma mark - UISearchDisplayController delegate methods

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    //先清空数组
    [_searchPoiArray removeAllObjects];
    
    if(![NSString isNullOrEmpty:searchText]){
        _searchString = searchText;
        if(_mapLocationStyle == MapLocationStyleSelectSinglePOI){
            [self searchSelectSinglePoiBySearchString:searchText];
        }else{
            [self searchPoiBySearchString:searchText];
        }
    }
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    _searchString = searchController.searchBar.text;
    searchPage = 1;
    [self searchPoiBySearchString:_searchString];
}

//自定义搜索取消button title
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
    headView.frame = CGRectMake(0, YS_STATUS_HEIGHT, YS_SCREEN_WIDTH, 44);
    self.mapView.frame=CGRectMake(0, YS_STATUS_NAV_HEIGHT, YS_SCREEN_WIDTH, YS_SCREEN_HEIGHT/2-40);
    if (STATUS_BAR_BIGGER_THAN_20 && !YS_IPHONEX) {
        self.mapView.y = YS_STATUS_NAV_HEIGHT-20;
    }
    self.tableView.frame = CGRectMake(0, self.mapView.frame.origin.y+self.mapView.frame.size.height, YS_SCREEN_WIDTH, self.view.frame.size.height-(self.mapView.frame.origin.y+self.mapView.frame.size.height));
    CGPoint oldCenter = self.mapView.logoCenter;
    followBtn.frame = CGRectMake(self.mapView.bounds.size.width - oldCenter.x-20, self.mapView.frame.size.height+self.mapView.frame.origin.y-60, 44, 44);
    centerMaker.center = CGPointMake(self.mapView.bounds.size.width/2,self.mapView.bounds.size.height/2);
    [_aSearchBar setShowsCancelButton:YES animated:NO];
    
    
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    
    headView.frame = CGRectMake(0, YS_STATUS_NAV_HEIGHT, YS_SCREEN_WIDTH, 44);
    self.mapView.frame=CGRectMake(0, YS_STATUS_NAV_HEIGHT+self.aSearchBar.frame.size.height, YS_SCREEN_WIDTH, YS_SCREEN_HEIGHT/2-40);
    if (STATUS_BAR_BIGGER_THAN_20 && !YS_IPHONEX) {
        self.mapView.y = YS_STATUS_NAV_HEIGHT+self.aSearchBar.frame.size.height-20;
    }
    self.tableView.frame = CGRectMake(0, self.mapView.frame.origin.y+self.mapView.frame.size.height, YS_SCREEN_WIDTH, self.view.frame.size.height-(self.mapView.frame.origin.y+self.mapView.frame.size.height));
    CGPoint oldCenter = self.mapView.logoCenter;
    followBtn.frame = CGRectMake(self.mapView.bounds.size.width - oldCenter.x-20, self.mapView.frame.size.height+self.mapView.frame.origin.y-60, 44, 44);
    centerMaker.center = CGPointMake(self.mapView.bounds.size.width/2,self.mapView.bounds.size.height/2);
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    [_searchController.searchResultsTableView setDelegate:self];
    
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    //    tableView.showsVerticalScrollIndicator = NO;
    [tableView setContentInset:UIEdgeInsetsMake(45, 0, self.mapView.frame.size.height+YS_STATUS_NAV_HEIGHT, 0)];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    if(_mapLocationStyle == MapLocationStyleSelectSinglePOI){
        for(UIView *subview in self.searchController.searchResultsTableView.subviews) {
            if([subview isKindOfClass:[UILabel class]]){
                [(UILabel *)subview setText:@""];
            }
        }
    }
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][searchOption]];
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchPoiArray removeAllObjects];
    if(_mapLocationStyle == MapLocationStyleSelectSinglePOI){
        [self searchSelectSinglePoiBySearchString:_searchString];
    }else{
        [self searchPoiBySearchString:_searchString];
    }
}

#pragma mark - Action
- (void)loadMoreData
{
    searchPage++;
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
    [self searchPoiByAMapGeoPoint:point];
    isFromMoreLoadRequest = YES;
}
- (void)searchLoadMoreData{
    searchPage++;
    if(_mapLocationStyle == MapLocationStyleSelectSinglePOI){
        [self searchSelectSinglePoiBySearchString:_searchString];
    }else{
        [self searchPoiBySearchString:_searchString];
    }
}

/**
 *  点击确定按钮
 */
-(void) SureAction {
    if(TARGET_IPHONE_SIMULATOR){
        NSLog(@"模拟器无法进行定位操作，请在真机中使用");
    }else if (TARGET_OS_IPHONE){
        if(_mapLocationStyle == MapLocationStyleSelectSinglePOI){
            if(_selectedIndexPath.row == 0){
                _selectedPoi = [_poiArray firstObject];
            }
        }
        if(self.mapSuccessPOIBlocks){
            MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
            pre.showsAccuracyRing=NO;
            CLLocationCoordinate2D centerCoordinate = _mapView.region.center;
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = centerCoordinate;
            if(_mapLocationStyle != MapLocationStyleSelectSingle){
                [_mapView addAnnotation:pointAnnotation];
            }
            [self.mapView updateUserLocationRepresentation:pre];
            
            [centerMaker removeFromSuperview];
            self.mapSuccessPOIBlocks(self.mapView,_selectedPoi);
        }
    }
}

/**
 *  跟随标注
 */
-(void)followMark{
    if(_mapLocationStyle != MapLocationStyleSelectSinglePOI){
        if (_poiArray.count > 1) {
            [_poiArray removeObjectsInRange:NSMakeRange(1, _poiArray.count-1)];
        }
    }
    else{
        [_poiArray removeAllObjects];
    }
    
    [self.tableView reloadData];
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude longitude:_mapView.userLocation.coordinate.longitude];
    if(_mapLocationStyle == MapLocationStyleSelectSingle){
        [self searchReGeocodeWithAMapGeoPoint:point];
    }
    else if (_mapLocationStyle == MapLocationStyleSelectSinglePOI){
        [self searchPoiByAMapGeoPoint:point];
    }
    else{
        [self searchReGeocodeWithAMapGeoPoint:point];
        [self searchPoiByAMapGeoPoint:point];
    }
    // 范围移动时当前页面数重置
    searchPage = 1;
    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
    
}

#pragma mark 定位权限判断
-(void)locationPermissions{
//    if(![SystemPrivilegesUtilViewModel locationServicesEnabled]){
//        [SystemPrivilegesUtilViewModel locationSession];
//    }else{
    
        if(_isContinuousPositioning && ( _mapLocationStyle == MapLocationStyleSelectSingle || _mapLocationStyle == MapLocationStyleSelectSinglePOI )){
            self.locationManager = [[AMapLocationManager alloc] init];
            self.locationManager.delegate = self;
            [self.locationManager setLocatingWithReGeocode:YES];
            [self.locationManager startUpdatingLocation];
            self.locationManager.distanceFilter = 200; //持续定位距离设置
            isFirstLocated = YES;
        }
        self.mapView.showsUserLocation = YES;//开启定位
        self.mapView.userTrackingMode = MAUserTrackingModeFollow; // 追踪用户位置.
        
//    }
}


#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
    if(_mapLocationStyle == MapLocationStyleSelectSingle){
        [self searchReGeocodeWithAMapGeoPoint:point];
    }
    else if (_mapLocationStyle == MapLocationStyleSelectSinglePOI){
        // 范围移动时当前页面数重置
        searchPage = 1;
        [self searchPoiByAMapGeoPoint:point];
    }
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//动画弹跳效果关键代码
//弹跳多次可自行多嵌套几次   调用此方法  只需传入弹跳对象e
- (void)animationShootOut:(UIImageView *)animationView{
    
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void){
        
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            //弹起
            animationView.center = CGPointMake(centerMaker.center.x, centerMaker.center.y-20);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void){
                //下降
                animationView.center = CGPointMake(self.mapView.bounds.size.width/2,self.mapView.bounds.size.height/2);
            } completion:^(BOOL finished){
                //                [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                //                    //弹起
                //                    animationView.frame = CGRectMake(frame.origin.x, frame.origin.y-10, frame.size.width, frame.size.height);
                //                } completion:^(BOOL finished){
                //                    //下降
                //                    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                //                        animationView.frame = frame;
                //                    } completion:^(BOOL finished){
                //                    }];
                //                }];
            }];
        }];
    }];
}

@end
