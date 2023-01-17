// Global nesneler
var tree 		= {Solution:[],Family:[],Modul:[],Wbo:[]}; // tree;
var treeExtra 	= {subMenu:[],menu:[]}; // treeExtra
var responsiveMenus = {pageBar:[],tabMenus:[]};
var pageDetail	= {
					'host' 		: $(location).attr('host'),  		  	 // www.test.com:8082
					'hostName' 	: $(location).attr('hostname'),      	// www.test.com
					'port'		: $(location).attr('port'),            // 8082
					'protocol'	: $(location).attr('protocol'),       // http
					'pathName' 	: $(location).attr('pathname'),      // index.ccc
					'href'		: $(location).attr('href'),         // http://www.test.com:8082/index.ccc#tab2
					'hash'		: $(location).attr('hash'),        // #tab2
					'search'	: $(location).attr('search'),     // ?foo=123
				}; // pageDetail
				
var	keyCodes = {
				
				'left'	: 37,
				'up'	: 38,
				'right'	: 39,
				'down'	: 40,
				'enter'	: 13,
				'esc'	: 27,

			};// keyCodes				

var cases = {
				'ç': 'c',
				'ı': 'i',
				'ş': 's',
				'ü': 'u',
				'ö': 'o',
				'ğ': 'g' 
};
var regcases = [
	{ key: 'ç', rgx: /ç/gi, val: 'c' },
	{ key: 'ı', rgx: /ı/gi, val: 'i' },
	{ key: 'ş', rgx: /ş/gi, val: 's' },
	{ key: 'ü', rgx: /ü/gi, val: 'u' },
	{ key: 'ö', rgx: /ö/gi, val: 'o' },
	{ key: 'ğ', rgx: /ğ/gi, val: 'g' }
]
/**
	//////////////////////////////////// app.js Layout Functions /////////////////////////////
	
	
	//
	Menus :
		leftMenu 		:
		leftMenuSearch 	:
		headerMenu		:
		headerMenuOther	:
		
	//
	tabMenus :
		set 		:
		sort		:
		sortSave	:
		
	//
	openPanel :
		leftPanel	:
		rightPanel	:
		userPanel	:
		
	//
	openMenus :
		settingMenus	:
		treeMenu		:
	
	//
	keyControl :
		leftPanel	:
			
	//
	pageBar	:
		set 		:
		sort		:
		sortSave	:
		
	menuControl		:
	
	
	////////////// Oluşturan : Emrah Kumru
**/ 

var JsonGroup  = function (){
	
		return {
			
			first : function (data){
				//console.log (data);
			
				$.each(data, function ( key,value ){
					
					if( key != 'DATA') return true; 
					
					for( var i in value ){
						
						var solution        = value[i][1];	// Solution 
						var solutionType	= value[i][6];	// Type
						var addedSolution   = false; 		// For Control 
			
						if (!solution) continue; // solution null control
						
							$.map(tree.Solution, function (key){									
									if( key.name == solution ) return  addedSolution = true; // solution control
							});//map solution control
							
						if ( !addedSolution ){
							
								tree.Solution.push({
										'name' : solution,
										'id'   : i,
										'type' : solutionType
								});// tree Solution push	
															
								for ( var j in value ){
									
										var family   	  = value[j][2]; // Family 
										var addedFamily   = false; // For Control	
			
												if ( value[j][1] == solution  ){
			
														$.map( tree.Family, function (key){									
																if( key.name == family  && key.solutionId == i ) return  addedFamily = true; // family control
														});//map family control
			
														if( !addedFamily ){
																tree.Family.push({
																		'name'         : family,
																		'id'           : j,
																		'solutionId'   : i
																});// tree Family push
			
																for ( var m in value ){
																	
																		var modul       = value[m][3]; // Modul
																		var addedModul  = false; // For Control
			
																		//console.log(value[m][0]);
																		if ( value[m][1] == solution && value[m][2] == family  ){
			
																				//console.log(family);
																				$.map(tree.Modul,function (key){
																						if( key.name == modul  && key.familyId == j  ) return  addedModul = true; // modul control
																				});//map modul control
			
																				if( !addedModul ){
																						tree.Modul.push({
																								'name'      : modul,
																								'id'        : m,
																								'familyId'  : j
																						});// tree Modul push
			
																						for (var k in value ){
																							
																							var wboType   		= value[k][0]; // wbo type
																							var wbo		  		= value[k][4]; // wbo
																							var wboUrl 	  		= value[k][5]; // wbo url
																							var urlType			= value[k][7] != null ? value[k][7].toLowerCase() : ''; // popUp type
																							var pageType		= value[k][14] != null ? value[k][14].toLowerCase() : ''; // window type
																							var wboId			= value[k][8]; // popUp type
																							var extraWboUrl 	= value[k][12]; // extra wbo url
																									
																							if( value[k][1] == solution && value[k][2] == family && value[k][3] == modul ){
			
																								//console.log(modul,value[k][4]);	
																								tree.Wbo.push({
																										'name' 			: wbo,
																										'modulId'  		: m,
																										'wboUrl'    	: wboUrl,
																										'addOn'			: wboType,
																										'urlType'		: urlType,
																										'pageType'		: pageType,
																										'wboId'			: wboId,
																										'extraWboUrl'	: extraWboUrl
																								});// tree Modul push
																								
																							} // Wbo in array 
																							
																						}//for value.length (Wbo )
																				}// !in array Modul						
																		} // family in array  
																}//for value.length (Modul)
														}// !in array Family		
												}// solution in array 
										}//for value.length (family )
								}// !in array Solution
							}// for value.length (solution)
				});//each 
				//console.dir(tree);
				
			}, //first
		
			second : function (data){

			//console.log (data);
		
			//extra menu ''second
			var __subMenu	= treeExtra.subMenu; 	   // object subMenu
			var __menu		= treeExtra.menu;		  // object menu
			
			$.each( data, function(key,val) {
					//console.log (key,val)
					if( key != 'DATA') return true; 
					
					for ( var i in val ) {
						
							var subMenuId	= val[i][0]; // menu item id 
							var subMenuType	= val[i][1]; // link type
							var subMenuName	= val[i][2]; // link name
							var subMenuUrl	= val[i][3]; // url
							var subMenuParentId= val[i][4]; // parent id 
						
							//Layer && normal && site dışı url
							if ( subMenuType == 9 || subMenuType == 13 || ( subMenuType == 1 && subMenuParentId == 0 ) ){
									
									__subMenu.push({
											id	: subMenuId,
											name : subMenuName,
											type : subMenuType,
											url  : subMenuUrl
										}); //__subMenu push				
								
									for ( var j in val ) {
										
										var menuType	= val[j][1]; // link type
										var menuName	= val[j][2]; // link name
										var menuUrl		= val[j][3]; // url
										var menuParentId= val[j][4]; // parent id 
	
										if ( menuParentId == subMenuId ) {
										
											__menu.push({
												
													parentId : menuParentId,
													name : menuName,
													type : menuType,
													url : menuUrl,	
												
												}); // __menu push
											
											}// if parent == id 
										
										} // for menu
	
								}// if type == 9
						}// for submenu 
				});//each 
		
		} // second
			
			}
	
	}; // JsonGroup
	
var menus = function ( setting ){
	//console.log( setting );
	
	var docType		= ".json";
	var path		= "/documents/personal_settings/userGroup_";
	var id			= setting.id;
	var standard	= setting.standart;
	var data		= setting.data;
	var url			= path + id + docType;

	if(id){

			$.ajax({ url: url, async:false, success: function(data) {
					//console.log(data);
					var json = JsonGroup();
					(standard == 'first') ? json.first(data) : json.second(data);
			   }
			}); // ajax
			
		} //if
		
	if (data){
			
			var json = JsonGroup();
			(standard == 'first') ? json.first(data) : json.second (data);
		
		}//if
		
	return {
		
		leftMenu : function ( el ) {
			//console.log ( el )
			//console.log ( standard )
				
				var addOnClass = 'specialWbo'; // add on wbo class name;

				//create solution 
				//return false;
				$('<ul>')
						.addClass('menu-content closeMenu')
						.append(function () {
								if ( standard == 'first' ){
									
											//standard menu 
											var Solution 		= tree.Solution; //Solution
											var leftMenuType	= 1; 
											
											var control = $.grep(Solution, function (v,k) {return v; }); //return v.type == leftMenuType ;

											for (var q in control) {
												
												var solutionName = control[q].name;
												var solutionId	 = control[q].id;

													//append created ul
													$('<li>')
															.addClass('menuItem')
															.append(function () {
																// element in solution
																$('<a>')
																		.attr('href', 'javascript:void(0)')
																		.append(
																				$('<div>').addClass('iconBox color-' +  solutionName.substr(0, 2) ).text( solutionName[0] ),
																				$('<span>').addClass('title').append( solutionName ),
																				$('<span>').addClass('arrow')
																		).appendTo(this);
								
																//create Family
																$('<ul>')
																	.addClass('sub-menu')
																	.append(function () {
																		// create family item 
																		$(this).append(function () {
																			
																			var family = tree.Family; // Family in Tree Obj
																			var control = $.grep(family, function (v,k) { return v.solutionId == solutionId ;  });
																			
																			for (var i in control) {
																				
																				var familyName = control[i].name;
																				var familyId   = control[i].id;
											
																					$('<li>')
																						.attr('id', familyId)
																						.append(function () {
																							// li in elements
																							$('<a>')
																								.attr('href', 'javascript:void(0)')
																								.append(
																										$('<i>').addClass('fa fa-cube fa-lg'),
																										$('<span>').addClass('title').append( familyName),
																										$('<span>').addClass('arrow')
																								).appendTo(this);
								
																							//create modul ul
																							$('<ul>')
																								.addClass('sub-menu')
																								.append(function () {
								
																									var modul = tree.Modul; // Modul in Tree Obj
																									var control = $.grep(modul, function (v,k) { return v.familyId == familyId ;  });
																									
																									for (var j in control) {
										
																										var modulName = control[j].name;
																										var modulId   = control[j].id;
																								
																											//create li
																											$('<li>')
																												.append(
																												
																													// li in elements
																													$('<a>')
																														.attr('href', 'javascript:void(0)')
																														.append( modulName,	$('<span>').addClass('arrow') ),
																														
																													//create Wbo ul 
																													$('<ul>')
																														.addClass('sub-menu')
																														.append(function () {
								
																															var wbo = tree.Wbo; // Wbo in Tree obj
																															var control = $.grep(wbo, function (v,k) { return v.modulId == modulId ;  });
																															
																															for (var k in  control) {
																																
																																	var wboName 	= control[k].name;
																																	var wboType 	= control[k].addOn;	
																																	var wboUrl		= control[k].wboUrl;
																																	var urlType 	= control[k].urlType != null ? control[k].urlType.toLowerCase() : '';// popup type
																																	var pageType	= control[k].pageType != null ? control[k].pageType.toLowerCase() : ''; // window type
																																	var extraWboUrl = control[k].extraWboUrl;
																																	var addClass  	= '';
																																						
																																	if ( wboType > 1 ) addClass = addOnClass;
					
																																	//create li 
																																	$('<li>').append(function(){
																																			//li in elements
																																			var url = 'index.cfm?fuseaction=' + wboUrl,
																																				__attr;
																																			
																																			if(extraWboUrl != '' && extraWboUrl != null)
																																				url = url + '&' + extraWboUrl;
																																				
																																			external = 0;
																																			if(wboUrl && wboUrl.indexOf('http') != -1)
																																			{
																																				url = wboUrl;
																																				external = 1;
																																			}
																																			
																																			if( pageType == 'popup' ) __attr = {'href' : 'javascript://','onClick' :"windowopen('/"+url+"','"+urlType+"' )" };
																																			else if( pageType == 'draggable' ) __attr = {'href' : 'javascript://','onClick' :"openBoxDraggable('"+url+"')" };
																																			else __attr = {'href': '/'+ url +''};
	
																																			if(external == 1)
																																			{
																																				addClass = 'externalFuseaction';
																																				__attr = {'href': '/'+ url +'','target':'_blank'};
																																			}
																																				
																																			$('<a>')
																																				.addClass(addClass)
																																				.attr(__attr)
																																				.append(
																																						//a in elements
																																						$('<div>').addClass('objectText').text( wboName ) ,
																																						$('<span>').addClass('objectAdd')
																																						
																																				).appendTo(this)
																																	}).appendTo(this);
																															} // for Wbo in Tree 
																														}).appendTo(this)
																														
																													).appendTo(this);
																										
																									}// for Family in Tree
								
																								})//created element ul
																								.appendTo(this);
																							})// created element li 
																						.appendTo(this);
																				}// for Family in Tree
																			});// ul append
																		}).appendTo(this);// created element ul 
															}).appendTo(this);//created element li
															
												};// For tree
										
										}else {
											
											//extra menu
											var subMenu = treeExtra.subMenu;
											var menu	= treeExtra.menu; 
											var pageLink = '/index.cfm?fuseaction=';
											var __http	= 'http://';
													
											
											for ( var x in subMenu ) {
												
													var name	= subMenu[x].name;
													var id		= subMenu[x].id;
													var type 	= subMenu[x].type;
													var _url	= subMenu[x].url;
												
												
													//console.dir(q)
													//append created ul
													$('<li>')
															.addClass('menuItem')
															.append(function () {
																// element in solution
																
																if ( type == 1 ){
																	var __href = pageLink + _url;
																	}else if ( type == 13 ){
																		var __href = __http + _url;
																		}else if ( type == 9 ) {
																			 var __href = 'javascript:void(0)';
																			} // if control
															
																
																$('<a>')
																		.attr('href', __href)
																		.append(function(){
																			
																					//class		
																					$('<div>')
																						.addClass('iconBox color-' +  name.substr(0,1) )
																						.text(  name[0] )
																						.appendTo(this);
																					//name	
																					$('<span>')
																						.addClass('title')
																						.append(name)
																						.appendTo(this);
																				//type layer 		
																				if ( type == 9 )$('<span>').addClass('arrow').appendTo(this);
																		}).appendTo(this);
																		
																//create menu ul 
																$('<ul>')
																	.addClass('sub-menu')
																	.append(function(){
																		
																		var _this	= this ;
																		
																		for ( var z in menu ){
																			
																			var parentId = menu[z].parentId;
																			var menuName = menu[z].name;
																			var menuUrl	 = menu[z].url;
																			
																			
																			//menu in subMenu control
																			if ( parentId != id  ) continue;
																			
																			$('<li>')
																				.append(
																					$('<a>')
																						.attr('href', pageLink + menuUrl )
																						.append(
																								$('<i>').addClass('fa fa-cube fa-lg'),
																								//$('<i>').addClass('fa fa-' + family[i].name),
																								$('<span>')
																									.addClass('title')
																									.append( menuName )
																								)
																				).appendTo(_this);
																		};// for z menu
																	})
																	.appendTo(this);
															})
															.appendTo(this);
												}; // for x subMenu
											
									}// if  standard control
						}).appendTo(el);
				//.after( $('<div>').addClass('clearfix') );
				
			}, //leftMenu
		
		leftMenuSearch : function ( el, responseEl, leftMenu ){
			//console.log ( el, responseEl, leftMenu )
			
				var wboUrl = 'index.cfm?fuseaction=';
	
					el.on('keyup',function (e){
						
						var keyCode = e.keyCode || e.which ;
						
						if ( keyCodes.up == keyCode || keyCodes.down == keyCode ) el.blur();
			
						var data = $.trim( $(e.currentTarget).val() );
						
							//console.log(data.length);
							//console.log(data);
							
						if ( data.length > 0 ){
							
							leftMenu.hide(); 
							responseEl.slideDown('fast');
							responseEl.empty();
							
							$('<ul>')
								.addClass('sub-menu')
								.append(function (){
			
									if ( standard == 'first' ){
										
										searchData = stringToLowerCase(data).split(' ');
										var regarr = [];
										for ( var i = 0; i < searchData.length; i++ ) {
											for (var k = 0; k< regcases.length; k++) {
												searchData[i] = searchData[i].replace(regcases[k].rgx, regcases[k].val);
											}
											regarr.push( new RegExp( searchData[i], 'gi' ) );
										}
											//standart menu search

											var searchResponse =  tree.Wbo.filter(function ( element, index ){
												
													if ( element.name == null ) return ;
														wboName = stringToLowerCase(element.name);
														 for ( var i = 0; i < wboName.length; i++ ) {
															for ( var k = 0; k< regcases.length; k++ ) {
																wboName = wboName.replace(regcases[k].rgx, regcases[k].val);
															}
														}
														var result = true;
														for ( i = 0 ; i < regarr.length; i ++) {
															result = result && ( regarr[i].test(wboName) || regarr[i].test(wboName) ) ;
														}
													return result;
											}); // grep searchResponse
										
											//console.log ( tree.Wbo )
											//console.log(searchResponse);
											//console.log(searchResponse.length)
											if ( searchResponse.length == 0 ){
												
													$('<li>')
														.append(
															$('<a>')
																.attr('href','javascript:void(0)')
																.append( $('<span>').append( 'Aranan içerik bulunamadı' ) )
														).appendTo(this);
													return;
													
													}//if searchResponse.length control
												
												for (var i in searchResponse) {
					
														$('<li>')
															.append(function(){
															
																var urlType = searchResponse[i].urlType != null ? searchResponse[i].urlType.toLowerCase() : '';
																var pageType = searchResponse[i].pageType != null ? searchResponse[i].pageType.toLowerCase() : '';
																var url = wboUrl + searchResponse[i].wboUrl;
																var addClass = '';
																if(searchResponse[i].extraWboUrl != '' && searchResponse[i].extraWboUrl != null)
																	url = url + '&' + searchResponse[i].extraWboUrl;
																	
																	external = 0;
																	if(searchResponse[i].wboUrl.indexOf('http') != -1)
																	{
																		url = searchResponse[i].wboUrl;
																		external = 1;
																	}

																	if( pageType == 'popup' ) __attr = {'href' : 'javascript://','onClick' :"windowopen('/"+url+"','"+urlType+"' )" };
																	else if( pageType == 'draggable' ) __attr = {'href' : 'javascript://','onClick' :"openBoxDraggable('"+url+"')" };
																	else __attr = {'href': '/'+ url +''};
																		
																	if(external == 1)
																	{
																		addClass = 'externalFuseaction';
																		__attr = {'href': '/'+ url +'','target':'_blank'};
																	}
																		
																	$('<a>')
																		.attr(__attr)
																		.append( searchResponse[i].name )
																		.addClass(addClass)
																		.appendTo( this);
															}).appendTo( this );
												}// For searchResponse
												searchResponse = [];
										
										}else {
												//second menu search
												var searchResponse = $.grep( treeExtra.menu, function ( element, index ){
																var name     = String(element.name).toLowerCase(); 
																var searchData  = String(data).toLowerCase();
														 return name.indexOf( searchData ) >= 0 ;
													}); // grep searchResponse
										
												//console.log ( tree.Wbo )
												
												if ( searchResponse.length == 0 ){
													
														$('<li>')
															.append(
																$('<a>')
																	.attr('href','javascript:void(0)')
																	.append( $('<span>').append( 'Aranan içerik bulunamadı' ) )
															).appendTo(this);
														return;
														
														}//if searchResponse.length control
													
													for (var i in searchResponse) {
						
															$('<li>')
																.append(
																	$('<a>')
																		.attr('href',wboUrl + searchResponse[i].url )
																		.append( searchResponse[i].name )
																).appendTo( this );
													}// For searchResponse
													searchResponse = [];
												
											} // if standard control
			
								}).appendTo( responseEl );
								
						}else {
							
								responseEl.hide(); 
								leftMenu.slideDown('fast');	
								
							
							}// if data.lenght control
							
					});// onkeypress function
				
			}, //leftMenuSearch
		
		headerMenu : function ( el ) {
			//console.log(el)
				
				// create nav
				  $('<nav>')
					  .addClass('topLeftMenu')
					  .append(function(){
						   $('<ul>')
								.append(function () {
									
									if ( standard == 'first' ){
										
											//standart Menu
											var Solution	= tree.Solution;
											var control 	= $.grep(Solution, function(v, k){ return v.type == 1; }); 
											
//											console.log(tree.Solution);
											
											for (var i in control ) {
													
													// append created ul
													var solutionName = control[i].name;
													var solutionId 	 = control[i].id;
													
													$('<li>')
														.addClass('dropdown')
														.append(function () {
															
															$('<a>')
																.attr('href', 'javascript:void(0)')
																.append( solutionName, $('<i>').addClass('fa fa-angle-down') )
																.appendTo(this);
				
															$('<ul>')
																.addClass('dropdown-menu')
																.append(function () {
				
																	var Family	= tree.Family;
																	var control = $.grep(Family, function(v, k){ return v.solutionId == solutionId });
				
																	for (var k in control) {
																		
																		var familyName = control[k].name;
																		var familyId   = control[k].id;
		
																			//append created ul 
																			$('<li>')
																				.append(
																						$('<a>')
																							.attr({ 'href' : 'javascript:void(0)', 'onclick' : 'openLeftSubMenu(' + familyId  +')'})
																							.append( $('<i>').addClass('fa fa-cube'), familyName )
																						)
																				.appendTo(this);
																	}// For Family 
																}).appendTo(this);
														}).appendTo(this);
														
												}// For Solution
								
										}else {
											
												//extra Menu
												var subMenu = treeExtra.subMenu;
												var menu	= treeExtra.menu;
												var pageLink = '/index.cfm?fuseaction=';
												var __http	= 'http://';
												var othercount  = 5;
												
												var control = $.grep(subMenu,function(v, k) { return k <= othercount});
												
												for ( var i in control ){
													
														var subMenuId	= control[i].id;
														var subMenuName = control[i].name;
														var subMenuType = control[i].type;
														var subMenuUrl  = control[i].url;
												
														$('<li>')
															.addClass('dropdown')
															.append(function(){
																
																//type control
																if ( subMenuType == 1 ){
																	var __href = pageLink + subMenuUrl;
																	}else if ( subMenuType == 13 ){
																		var __href = __http + subMenuUrl;
																		}else if ( subMenuType == 9 ) {
																			 var __href = 'javascript:void(0)';
																			} // if control
																
																$('<a>')
																	.attr('href', __href )
																	.append(function(){
																			$(this).append(subMenuName);
																			//type layer 		
																			if ( subMenuType == 9 )$('<i>').addClass('fa fa-angle-down').appendTo(this);
																	})
																	.appendTo(this);
																
																	$('<ul>')
																		.addClass('dropdown-menu')
																		.append(function(){

																				var control =  $.grep(menu, function(v,k){ return  v.parentId == subMenuId; });
																			
																				for ( var k in control ) {
																							
																						var menuName	= control[k].name;
																						var menuType 	= control[k].type;
																						var menuUrl		= control[k].url;
																							
																						$('<li>')
																							.append(
																									$('<a>')
																									.attr('href' , pageLink + menuUrl )
																									.append(
																											$('<i>').addClass('fa fa-cube'),
																											menuName
																											)
																									)
																							.appendTo(this);	
																					};//for menu
																			})
																		.appendTo(this);
																})
															.appendTo(this)				
																										
													};// for subMenu
													
											};// if  standard control
									
								}).appendTo(this);
					  }).prependTo( el );
					  
  
			}, //headerMenu
		
		headerMenuOther : function ( el, data) {
			//console.log ( el );
					
				if (standard == 'first' ) {
				
						var Solution	= tree.Solution;
						var Family		= tree.Family;
						var Modul		= tree.Modul;
						var Wbo 		= tree.Wbo;
												
						$('<nav>')
							.addClass('topOtherMenu')
							.append(function() {
								
								$('<ul>')
									.attr('id','menuOther')
									.append(function() {
										
										$('<li>')
											.addClass('dropdown')
											.append(
													$('<a>')
														.attr('href','javascript:void(0)')
														.append( language.diger, $('<i>').addClass('fa fa-angle-down')),
														
														$('<ul>')
															.addClass('dropdown-menu')
															.append(function() {
//																console.log(Solution);
																for ( var i in Solution ) {
					
																	if ( Solution[i].type != 2 ) continue;
																	
																	var solutionName	= Solution[i].name;
																	var soluitionId		= Solution[i].id;
																									
																	$('<li>')
																		.append(function(){
																			$('<a>')
																				.attr('href','#')
																				.append( $('<i>').addClass( 'icon-' + solutionName ), solutionName ,$('<i>').addClass('fa fa-angle-right fa-lg menuArrow') )
																				.appendTo( this )
																				
																				$('<ul>')
																					.addClass('scrollContent')
																					.append(function(){
																					
																						var control = $.grep(Family, function(v, k) {return v.solutionId == soluitionId ; });
																										
																						for ( var q in control ) {
																							
																							var familyName	= control[q].name;
																							var familyId	= control[q].id 
																							
																									$('<li>')
																										.append(
																											$('<a>')
																												.attr('href','#')
																												.append( 
																														$('<i>').addClass('fa fa-cube fa-lg'),
																														familyName,
																														$('<i>').addClass('fa fa-angle-down fa-lg pull-right') 
																													),
																													//create modul
																													$('<ul>')																		
																														.append(function(){
																															
																															var control = $.grep(Modul, function(v, k) { return v.familyId == familyId; });
																															
																																for ( var  j in control ){
																																	
																																	var modulName	= control[j].name;
																																	var modulId		= control[j].id;
																										
																																		$('<li>')
																																			.append(
																																				$('<a>')
																																					.attr('href','#')
																																					.append( modulName, $('<i>').addClass('fa fa-angle-down fa-lg pull-right') ),
																																					
																																					//create wbo
																																					$('<ul>')
																																						.addClass('acordionContent')
																																						.append(function(){
																																							
																																							var control = $.grep(Wbo, function(v, k) { return v.modulId == modulId; });
																																							
																																								for ( var k in control ){
																																									
																																									var wboName	= control[k].name;
																																									var wboUrl	= control[k].wboUrl;
																																									var urlType = control[k].urlType != null ? control[k].urlType.toLowerCase() : '';
																																									var pageType = control[k].pageType != null ? control[k].pageType.toLowerCase() : '';
																																									
																																									var url 	= 'index.cfm?fuseaction=' + wboUrl,
																																									__attr;

																																									if( pageType == 'popup' ) __attr = {'href' : 'javascript://','onClick' :"windowopen('/"+url+"','"+urlType+"' )" };
																																									else if( pageType == 'draggable' ) __attr = {'href' : 'javascript://','onClick' :"openBoxDraggable('"+url+"')" };
																																									else __attr = {'href': '/'+ url +''};

																																									//create li 
																																									$('<li>').append(
																																										//li in elements
																																										$('<a>')
																																											.attr(__attr)
																																											.append( wboName, $('<span>').addClass('objectAdd') )
																																									).appendTo(this);

																																								}//for Wbo
																																							})//append wbo
																																						.appendTo(this)
																																				)//append Modul
																																				.appendTo(this);
																																	}// for Modul
																															})//append Family
																														.appendTo( this )
																												)//append family 
																										.appendTo( this );
																										
																							}// for Family
																							
																							
																						})// append ul .dropdown-menu
																					.appendTo(this);
																			})// append Solution
																		.appendTo( this );
																		
																} //for Solution 
																
															})
												)//li .dropdown
											.appendTo(this);
									})//ul
									.appendTo(this)
							})//nav .topOtherMenu
							.appendTo( el );
				}else {
					
						var subMenu = treeExtra.subMenu;
						var menu	= treeExtra.menu;
						var pageLink = '/index.cfm?fuseaction=';
						var __http	= 'http://';
						var othercount  = 5;
						
						
						$('<nav>')
							.addClass('topOtherMenu')
							.append(function() {
								
								$('<ul>')
									.attr('id','menuOther')
									.append(function() {
										
										$('<li>')
											.addClass('dropdown')
											.append(
													$('<a>')
														.attr('href','javascript:void(0)')
														.append( language.diger, $('<i>').addClass('fa fa-angle-down')),
														
														$('<ul>')
															.addClass('dropdown-menu')
															.append(function() {
																
																var control = $.grep(subMenu,function(v, k) { return k > othercount});
																
																for ( var i in control ){
																	
																		var subMenuId	= control[i].id;
																		var subMenuName = control[i].name;
																		var subMenuType = control[i].type;
																		var subMenuUrl  = control[i].url;
																
																		$('<li>')
																			.append(function(){
																				
																				//type control
																				if ( subMenuType == 1 ){
																					var __href = pageLink + subMenuUrl;
																					}else if ( subMenuType == 13 ){
																						var __href = __http + subMenuUrl;
																						}else if ( subMenuType == 9 ) {
																							 var __href = 'javascript:void(0)';
																							} // if control
																				
																				$('<a>')
																					.attr('href', __href )
																					.append(function(){
																							$(this).append(subMenuName);
																							//type layer 		
																							if ( subMenuType == 9 )$('<i>').addClass('fa fa-angle-right fa-lg menuArrow').appendTo(this);
																					})
																					.appendTo(this);
																				
																					$('<ul>')
																						.addClass('scrollContent')
																						.append(function(){
				
																								var control =  $.grep(menu, function(v,k){ return  v.parentId == subMenuId; });
																							
																								for ( var k in control ) {
																											
																										var menuName	= control[k].name;
																										var menuType 	= control[k].type;
																										var menuUrl		= control[k].url;
																											
																										$('<li>')
																											.append(
																													$('<a>')
																													.attr('href' , pageLink + menuUrl )
																													.append( $('<i>').addClass('fa fa-cube'), menuName )
																													)
																											.appendTo(this);	
																									};//for menu
																							})
																						.appendTo(this);
																				})
																			.appendTo(this)				
																														
																	};// for subMenu
																
															})
												)//li .dropdown
											.appendTo(this);
									})//ul
									.appendTo(this)
							})//nav .topOtherMenu
							.appendTo( el );

					} // if standart control

			} // headerMenuOther
		
		} //return 
	
	};//Menus

var tabMenus = function (handler,data, el, index, controllerName, eventList,iconSettings){
//	console.log ( eventList);
	$("#tabMenu").html('');
	var returnDefaultValue = 0;
	"use strict";

	var eventListSave = eventList , dataSaved = '';
	

		if (responsiveMenus.tabMenus.length != 0 || !data){
			
				var data			= responsiveMenus.tabMenus[0].data,
					iconSettings	= responsiveMenus.tabMenus[0].iconSettings,
					json 			= $.parseJSON( data ),
					object			= $.parseJSON(data);
		
			}else {

					$.ajax({ url :'WMO/pageDesigner.cfc?method=getMenuModified', data : {controller : controllerName,jsonType :1,eventList:eventList}, async:false,success : function(res){ if ( res ) { dataSaved = res; returnDefaultValue = 1} } });
					
					if(dataSaved.length)
					{
						elementObject = $.parseJSON(dataSaved);
						excontrollerData = $.parseJSON(data);
						var controllerData = $.parseJSON(data);
						var dataTemp = [];
						var str = 0;
						$.each(elementObject,function(val,key){
							var element = key.menus;
							$.each(element,function(val2,key2){
								if(key2.href)
									stringValueSaved = key2.href;
								else if(key2.onClick)
									stringValueSaved = key2.onClick;
								else
									stringValueSaved = key2.onclick;
							
								stringValueSaved = stringValueSaved.split('&')[0];
								$.each(excontrollerData,function(val3,key3){
									var element = key3.menus;
									$.each(element,function(val4,key4){
										if(key4.href)
											stringValueController = key4.href;
										else if(key4.onClick)
											stringValueController = key4.onClick;
										else
											stringValueController = key4.onclick;
									
										stringValueController = stringValueController.split('&')[0];
						
										if(stringValueSaved == stringValueController)
										{
											console.log(elementObject[val3]['menus'][val2],controllerData[val3]['menus'][str]);
											controllerData[val3]['menus'][str] = elementObject[val3]['menus'][val2];
											if(key4.href)
												controllerData[val3]['menus'][str]['href'] = excontrollerData[val3]['menus'][val4]['href'];
											else
												controllerData[val3]['menus'][str]['onclick'] = excontrollerData[val3]['menus'][val4]['onclick'];
											
											str = str + 1;
										}
						
									})
								})
							})
						})
						
						
						var json = controllerData, object = controllerData;
						responsiveMenus.tabMenus.push( {'el':el[0],'data':JSON.stringify(controllerData),'controller' : controllerName, eventList : eventList, iconSettings : iconSettings || null });
					}
					else
						responsiveMenus.tabMenus.push( {'el':el[0],'data':data,'controller' : controllerName, eventList : eventList, iconSettings : iconSettings || null });
	
				}// if
		if(returnDefaultValue == 1)
			$("#tabMenuEdit input.hide").removeClass('hide').addClass('btn blue-sharp');
			
		var iconTagName = 'icon',
			arg;
		
		var functions = {
			
				set : function (){
					 
					 $('<ul>')
						.append(function (){
							
								var ul = this ;
								var indis = index || 4;
								
									//menus
									$.each(json,function ( key, val){
										//console.log (key, val );
										
											if ( val.menus ){
												
												var menus = val.menus;
												
												$.each(menus,function(k,v){

														if(v.active == undefined || v.active)
														{
															var _href	= v.href || v.Href,
																 _text	= v.text || v.Text,
																 aEl;
														
															if ( _href ) {
																
																	var _target = v.target || v.Target;	
																		aEl = $('<a>').attr({'href': _href ,'target': _target }).append( _text );
																
																}else {
																	
																	var _onClick = v.onClick || v.onclick
																		aEl = $('<a>').attr({'onClick': _onClick,'href':'javascript:;'} ).append( _text )
																	
																	} // if _href
												
															if ( k >= indis ) return false; 
																	
															$('<li>')
																.addClass('dropdown')
																.append( aEl )
																.appendTo( ul );
														}
															
													});//each val
									 
													if( Object.keys(menus).length > indis ){
														
															//menus outher 
															$('<li>')
																.addClass('dropdown')
																.append(function(){
																	
																	$('<a>')
																		.attr('href','javascript://')
																		.addClass('otherTabMenu')
																		.append(
																				language.diger,
																				$('<i>').addClass('fa fa-angle-down fa-lg')
																			)
																		.appendTo(this);
																	
																	 $('<ul>')
																		.addClass('dropdown-menu scrollContent scrollContentDropDown')
																		.append(function(){
																			
																			var __ul = this ;
										
																			 $.each(menus,function ( key, val){
																				//console.log ( val );
																				
																				if(val.active == undefined || val.active)
																				{
																					var _href	= val.href || val.Href,
																						_text 	= val.text || val.Text,
																						aEl;
																				
																					if ( _href ) {
																						
																							var _target = val.target || val.Target;	
																								aEl = $('<a>').attr({'href': _href ,'target': _target }).append( _text );
																								
																						}else {
																							
																							var _onClick = val.onClick || val.onclick;
																								aEl = $('<a>').attr({'onClick': _onClick,'href':'javascript:;'} ).append( _text )
																							
																							} // if _href
																					
																					
																					if ( key < indis ) return true; 
																							
																					$('<li>')
																						.append( aEl )
																						.appendTo( __ul );
																				}
																			 }); // updeach
																			
																			})
																		.appendTo( this );
																	})
																.appendTo(ul);
																
														}//if
												
												}//if val.menus 
												
											if ( val.icons ){
												
												var icons = val.icons,sorter;
												 
													if ( val.icons.extra ){
												
															var iconsExtra = val.icons.extra;
															
															//iconsExtra
															$.each(iconsExtra, function (key, val){
																//console.log (key, val );
																
																var _href	= val.href || val.Href,
																	_text	= val.text || val.Text,
																	_status	= val.status || val.Status,
																	aAttr,aEl;
																	
																var iconClass = iconTagName + '-' + _text ;
																var iconPassiveClass = 'icon-passive';
																
																( !_status ) ? aAttr = { 'href' : 'javascript:void(0)' , 'class' : iconPassiveClass }  : aAttr = { 'href' : _href }; 
																
																if ( _href ) aEl = $('<a>').attr( aAttr ).append( $('<i>').addClass( iconClass ));
																		
																$('<li>')
																	.addClass('dropdown')
																	.append( aEl )
																	.appendTo( ul );
																	
																}); //iconsExtra each 	
													
														}; // val.icons.extra	
														
													//icons
													if ( iconSettings ) {
														//console.log(iconSettings);
																sorter = {};
																
																$.each(iconSettings,function(){
																 
																		var icon = this;
																		
																		$.each(icons,function(k, v){ 
																		
																				 	if ( String( k ) === String (icon)){ sorter[k] = v } //if
																						
																				 	if( iconSettings.indexOf(k) === -1 ){ sorter[k] = v } // if
																				
																				 }); // each
																						 
																	 }); //each
																
																icons = sorter;
										 
										 					} //if
															
											
													$.each(icons,function ( key, val){
														//console.log (key, val );
														
														if ( key == 'extra' ) return; // object control;
														

														
														var _href	= val.href || val.Href,
															 _text 	= val.text || val.Text,
															 aEl;
													
														if ( _href ) {
															
																var _target = val.target || val.Target;	
																	aEl = $('<a>').attr({'href': _href ,'target': _target , 'title':_text}).append(  $('<i>').addClass( iconTagName + '-' + key ) );
																	
															}else {
																
																var _onClick = val.onClick || val.onclick;
																	aEl = $('<a>').attr({'onClick': _onClick,'href':'javascript:;', 'title':_text} ).append( $('<i>').addClass( iconTagName + '-' + key) )
																
																} // if _href
														
														$('<li>')
															.addClass('dropdown')
															.append( aEl )
															.appendTo( ul );	 
																
													 }); // upd each	
														
			
												}//val.icons
												
									 }); // json
							})
						.prependTo( el );
					 
					 },
			
				sort : function(){
					if(dataSaved.length)
					{
						var object			= controllerData;
					}
					else
						var object			= $.parseJSON(data);

						var modalId			= 'formPanel',
							editId			= 'editMenu',
							handle	        = 'form-group',
							sorter			= 'sorter',
							modal 			= $('*').find('div#' + modalId ),
							modalHeader		= modal.find('.modal-header'),
							modalBody		= modal.find('.modal-body'),
							modalFooter		= modal.find('.modal-footer'),
							editTab			= modal.find('#' + editId);

						var sortableSettings = {
										
										connectWith		: '.' + sorter,
										cursor			: 'move',
										opacity			: '0.6',
										placeholder		: 'form-group-corner-all',
										revert			: 300
										
								}; //sortableSettings
								
					//	console.log(object);
								
						 $('<div>')
							.addClass( 'col col-12' )
							.append(function(){
									
									$('<div>')
										.addClass('sorterHead')
										.append( $('<span>').addClass('pull-left sorterElementName').append(language.tabMenu) )
										.appendTo(this);
				
									$('<ul>')
										.addClass( sorter )
										.append(function(){
										
											var ul = this ;
										
											$.each(object, function(){
												
													if (this.menus) {
														$("#tabMenuLiPD").css('display','');
															$.each(this.menus, function (key,val) {

																	if(val.active == undefined || val.active)
																	{
																		$('<li>')
																			.addClass('handle')
																			.append(this.text,$("<input>").attr('type','checkbox').addClass('pull-right').prop('checked','checked'))
																			.appendTo( ul );
																	}
																	else
																	{
																		$('<li>')
																			.addClass('handle')
																			.append(this.text,$("<input>").attr('type','checkbox').addClass('pull-right'))
																			.appendTo( ul );
																	}
															
																}); // each 
																														
														
														} // if
	
												
												}); // each	
										})
										.appendTo(this)
										.sortable(sortableSettings);
										
								})
							.appendTo(editTab);
					
					
						var clickFunction = 'tabMenus("sortSave","","","","","'+eventList+'");';
						
						editTab.next('div.modal-footer').find('input#actionButton').attr('onClick', clickFunction);	
					
					},
					
				sortSave : function(){

						var modalId			= 'formPanel',
							editId			= 'editMenu',
							handle	        = 'form-group',
							sorter			= 'sorter',
							modal 			= $('*').find('div#' + modalId ),
							modalHeader		= modal.find('.modal-header'),
							modalBody		= modal.find('.modal-body'),
							modalFooter		= modal.find('.modal-footer'),
							editTab			= modal.find('#' + editId),
							object			= $.parseJSON(responsiveMenus.tabMenus[0].data),
							objectMenu		= object[Object.keys(object)[0]];

						if($("#controllerEvents"))
							eventListSave = $("#controllerEvents").val();
						
						var li		= editTab.find('ul.' + sorter + ' li.handle'),
							menus	= [],
							arr 	= [];
						
						$.map(objectMenu.menus,function(val){menus.push(val);});
							
						objectMenu.menus = {};
						
						$.each(li,function(val,key){
							
								var text = $(this).text();
								
								var checkbox = $(this).find('input[type="checkbox"]').prop('checked');

								var menu = $.grep(menus,function(val){ return val.text === text;});
								menu[0]['active'] 	= checkbox;
								menu[0]['order'] 	= val;
								arr.push(menu[0]);
										
							}); // grep

						objectMenu.menus = arr;

						$.ajax({
								url :'WMO/pageDesigner.cfc?method=menuModified', 
								data : {data : JSON.stringify( object ) , controller : responsiveMenus.tabMenus[0].controller, eventList : eventListSave, jsonType : 1 },
								success : function(res){
																	
										console.warn(res);
										location.reload();
									
									} // success
									
							}); // ajax
					},
					
					returnDefault : function(){
							$.ajax({
									url :'WMO/pageDesigner.cfc?method=delModified', 
									data : {controllerName : responsiveMenus.tabMenus[0].controller, jsonType : 1 },
									success : function(res){
																		
											console.warn(res);
											location.reload();
										
										} // success
										
							}); // ajax
						
						}
			
			}; // functions
		
		$.each(handler.split(','),function(){
			
				functions[this].apply();	
			
			}); // each
			
	} //tabMenus	
	
var pageBar = function (handler, el, index ) {

	"use strict";

		var urlSearch		= pageDetail.search,
			 __urlSearch	= urlSearch.substring( urlSearch.indexOf('=') + 1 ),
			 __foo			= __urlSearch.indexOf('&'),
			 otherNum		= index || 6,
			 pageBody		= $('.pageBody'),
			 data, response, edited;
		
		( __foo > 0 ) ? data = __urlSearch.slice( 0, __foo ) : data = __urlSearch; // url foo control
				
		var response = $.grep( tree.Wbo, function ( element, index ){
			
		/*	if(String(element.wboUrl).toLowerCase().indexOf('settings.') == -1) E.Y
			{*/
					var wboUrl		= String(element.wboUrl).toLowerCase(),
						searchData  = String( data ).toLowerCase();
					return  list_first(wboUrl,'&') == searchData ;  // wboUrl == searchData
	/*		}*/
		}); // grep response
			
		if ( !response.length ){
			
				el.remove(),pageBody.removeAttr('style'); 
				//pageTitle(null);
				return false;
				
			}// if response.length
			
		var wbo		= $.grep( tree.Wbo, function (val, key ){ var modulId = val.modulId, id = response[0].modulId; return modulId == id; }), // grep wbo
			modul	= $.grep( tree.Modul,function(val, key ){ var id = val.id; return wbo[0].modulId == id }); // grep modul	

		$.ajax({ url :'WMO/pageDesigner.cfc?method=getMenuModified', data : { objectId : wbo[0].wboId || null ,jsonType :2}, async:false, success : function(res){ response = res || null; } });	
		
		if (response){

				edited = [];
				
				$.each($.parseJSON(response),function(){
				 
						var wboId	= this;
						
						$.each(wbo,function(k, v){ if ( parseInt( v.wboId ) === parseInt (wboId)){ edited.push(v); } }); // each
										 
					 }); //each
				
				wbo = edited;
			
			} // if

		var functions = {
			
				set : function (){
					
						responsiveMenus.pageBar.push( {'el':el[0] });// push responsiveMenus
						
						$('<ul>')
							.addClass('page-breadcrumb')
							.append(function(){
								
								var e 			= $(this),
									modulName	= modul[0].name,
									addClass 	= '' ;
								
									$('<li>')
										.append( $('<a>').attr('href','javascript://').text(modulName).addClass(' bold') )
										.appendTo(this);
										
									//pageTitle(modulName);		
								
									$.each( wbo, function ( key, val ){
										
										if( key >= otherNum )  return false;
										
										var url 	= 'index.cfm?fuseaction=' + val.wboUrl,
											urlType = val.urlType != null ? val.urlType.toLowerCase() : '',
											pageType = val.pageType != null ? val.pageType.toLowerCase() : '',
											__attr;
											
											if(val.extraWboUrl != '' && val.extraWboUrl != null)
												url = url + '&' + val.extraWboUrl;
											
											if( pageType == 'popup' ) __attr = {'href' : 'javascript://','onClick' :"windowopen('/"+url+"','"+urlType+"' )" };
											else if( pageType == 'draggable' ) __attr = {'href' : 'javascript://','onClick' :"openBoxDraggable('"+url+"')" };
											else __attr = {'href': '/'+ url +''};
								
												
											external = 0;
											if(val.wboUrl.indexOf('http') != -1)
											{
												url = val.wboUrl;
												external = 1;
												addClass = 'externalFuseaction';
												__attr = {'href': '/'+ url +'','target':'_blank'};
											}
											
											$('<li>')
												.append( 
														$('<i>').addClass('fa fa-circle'),
														$('<a>').attr( __attr ).addClass(addClass).append( val.name )
													)
												.appendTo( e );
				
										});// each wbo
										
									if (  otherNum >=  wbo.length) return ;
									
										$('<li>')
											.addClass('otherPageBarMenu')
											.append( 
												$('<a>')
													.attr('href','javascript://')
													.append( language.diger ,$('<li>').addClass('fa fa-angle-down fa-lg')
												),
												
												$('<ul>')
													.addClass('dropdown-menu scrollContent scrollContentDropDown')
													.append(function(){
														
															var ul = this;
														
															$.each( wbo, function ( key, val ){
																
																if( key < otherNum )  return true;
																
																var url		= 'index.cfm?fuseaction=' + val.wboUrl,
																	urlType = val.urlType != null ? val.urlType.toLowerCase() : '',
																	pageType = val.pageType != null ? val.pageType.toLowerCase() : '',
																	__attr;
																	
																if(val.extraWboUrl != '' && val.extraWboUrl != null)
																	url = url + '&' + val.extraWboUrl;
															
																if( pageType == 'popup' ) __attr = {'href' : 'javascript://','onClick' :"windowopen('/"+url+"','"+urlType+"' )" };
																else if( pageType == 'draggable' ) __attr = {'href' : 'javascript://','onClick' :"openBoxDraggable('"+url+"')" };
																else __attr = {'href': '/' + url +''};
																	
																$('<li>').append( 
																	$('<a>').attr( __attr ).append( val.name )	
																).appendTo( ul );
										
															});// each wbo
														})
													.appendTo(this)
											)
											.appendTo(this);
								})
							.appendTo( el );
				
					},
					
				sort : function(){
					
						var modalId			= 'workDev',
							editId			= 'editBarx',
							handle	        = 'form-group',
							sorter			= 'sorter',
							modal 			= $('*').find('div#' + modalId ),
							modalHeader		= modal.find('.modal-header'),
							modalBody		= modal.find('.modal-body'),
							modalFooter		= modal.find('.modal-footer'),
							editTab			= modal.find('#' + editId);
							//object			= $.parseJSON(data);

						var sortableSettings = {
										
										connectWith		: '.' + sorter,
										cursor			: 'move',
										opacity			: '0.6',
										placeholder		: 'form-group-corner-all',
										revert			: 300
										
								}; //sortableSettings
								
						$('<div>')
							.addClass( 'col col-12' )
							.append(function(){
									
									$('<div>')
										.addClass('sorterHead')
										.append( $('<span>').addClass('pull-left sorterElementName').append(language.pageBar) )
										.appendTo(this);
				
									$('<ul>')
										.addClass( sorter )
										.append(function(){
										
											var ul = this ;
										
											$.each(wbo, function(){
														
													$('<li>')
														.attr('wboId',this.wboId)
														.addClass('handle')
														.append(this.name)
														.appendTo( ul );
												
												}); // each	
										})
										.appendTo(this)
										.sortable(sortableSettings);
										
								})
							.appendTo(editTab);
					
					
						var clickFunction = 'pageBar("sortSave",null);';
						
						editTab.next('div.modal-footer').find('input#actionButton').attr('onClick', clickFunction);			
					
					
					},
					
				sortSave : function(){
					
					
					var modalId			= 'formPanel',
						editId			= 'editBar',
						handle	        = 'form-group',
						sorter			= 'sorter',
						modal 			= $('*').find('div#' + modalId ),
						modalHeader		= modal.find('.modal-header'),
						modalBody		= modal.find('.modal-body'),
						modalFooter		= modal.find('.modal-footer'),
						editTab			= modal.find('#' + editId);
					
					var li			= editTab.find('ul.' + sorter + ' li.handle'),
						arr			= [];
					
						$.each(li, function(){
							
								arr.push( $(this).attr('wboId'));
							
							}); // each
						
						$.ajax({
								url :'WMO/pageDesigner.cfc?method=menuModified', 
								data : { data : JSON.stringify(arr) , objectId : arr[0], jsonType : 2 },
								success : function(res){
																	
										console.warn(res);
										location.reload();
									
									} // success
									
							}); // ajax
					
					}		
			
			
			}; // functions
			
		$.each(handler.split(','),function(){

				functions[this].apply();
			
			}); // each
			
	}; // pageBar
		
var menuControl = function (){
	//console.log ('test')

		// Solution menu Contol
		$(' .menu-content > li >  a ').on('click', function ( e ){
				//console.log ( e.currentTarget )
									
				var currentTarget = e.currentTarget;
				var visibleMenus = $('.menu-content > li > a:visible');
		
					$.each( visibleMenus, function ( key, val ) {
							//console.log ( val );
							var subMenu = $(val).next('ul.openSubMenu');
						
							if ( val != currentTarget ) {
								subMenu.slideToggle('fast', 'swing', function(){
									subMenu.toggleClass('openSubMenu');
								 
									 var __icon = $(val).parent('li').children('a').children('span:last');
									 if ( __icon.hasClass('arrow') ) __icon.toggleClass('arrow-down',200); 
				
									}); // visibleMenus
								} /// if val != currentTarget 
						}); // each visibleMenus
			}); // menu-content ul ul li a
		
		// Family menu Contol
		$(' .menu-content > li >  ul > li > a ').on('click', function ( e ){
				//console.log ( e.currentTarget )
									
				var currentTarget = e.currentTarget;
				var visibleMenus = $('.menu-content > li > ul > li > a:visible');
		
					$.each( visibleMenus, function ( key, val ) {
							//console.log ( val );
							var subMenu = $(val).next('ul.openSubMenu');
						
							if ( val != currentTarget ) {
								subMenu.slideToggle('fast', 'swing', function(){
									subMenu.toggleClass('openSubMenu');
									
									 var __icon = $(val).parent('li').children('a').children('span:last');
									 if ( __icon.hasClass('arrow') ) __icon.toggleClass('arrow-down',200); 
									
									}); // visibleMenus
								} /// if val != currentTarget 
						}); // each visibleMenus
			}); // menu-content ul ul li a
			
		// Modul menu Contol
		$(' .menu-content > li >  ul > li > ul > li a ').on('click', function ( e ){
				//console.log ( e.currentTarget )
									
				var currentTarget = e.currentTarget;
				var visibleMenus = $('.menu-content > li >  ul > li > ul > li a:visible');
		
					$.each( visibleMenus, function ( key, val ) {
							//console.log ( val );
							var subMenu = $(val).next('ul.openSubMenu');
						
							if ( val != currentTarget ) {		
								subMenu.slideToggle('fast', 'swing', function(){
									subMenu.toggleClass('openSubMenu');
									
									 var __icon = $(val).parent('li').children('a').children('span:last');
									 if ( __icon.hasClass('arrow') ) __icon.toggleClass('arrow-down',200); 
									
									}); // visibleMenus
								} /// if val != currentTarget 
						}); // each visibleMenus
			}); // menu-content ul ul li a	
	
		// Header Other menu Control
		$('#menuOther > li a').bind('click',function( e ){	
		
			$(this).next('ul').slideToggle(200);
		
		}); // #menuOther > li a
		$('.leftBar .menu-content').find('.menuItem').each(function( index ) {
			if($(this).offset().top>=500){
				$(this).find('.sub-menu').css('bottom','37px');
			}
		});	

		$("html[dir=RTL] .leftBar").delegate("li.menuItem","mouseenter mouseleave",function(event){
			if(!$(".leftBar").hasClass("leftBarOpen")){
				if(event.type == 'mouseenter') 
				{   
					
					if($(this).index() == 0){
						$(this).attr({style : "left:-1px; position:absolute !important;top:50px;"});
					}
					else $(this).attr({style : "left:-1px; position:absolute !important;"});
					$(".leftBar").find("li.menuItem").eq($(this).index() + 1).css({"margin-top": "37px"});
					
				}else{
					
					$(this).removeAttr("style");
					$(".leftBar").find("li.menuItem").eq($(this).index() + 1).css({"margin-top": "0px"});    
					
				}
			}
		});
	};//menuControl
	
var openPanel = function (params,XmlFuseact){
	//console.log(XmlFuseact);
	return {
		
		leftPanel : function ( e ) {
				var body			= $('body');
				var mainLayout		= $('#wrk_main_layout');
				var mainLayoutTd	= $('#wrk_main_layout > section#wrk_main_layout_td');	
				var leftBar			= $('.leftBar');
				var menuContent		= $('.menu-content');
				var leftMenuSearch	= $("#leftMenuSearch");
				var responseSearch	= $('#responseSearch');
				var openBtn			= $('.leftBarOpenBtn').parents().find('.page-logo');
				
				var panel = {
						panel  			:'leftBar',
						panelActive  	:'leftBarOpen',
						panelMenu		:'sidebar-menu',
						panelSearch		:'responseSearch',
					};//panel
				
				if ( !e ) {
				
						openBtn.click(function(){   
												
								  leftBar.toggleClass('leftBarOpen push');
								  mainLayoutTd.toggleClass('push');
								  menuContent.toggleClass('closeMenu');
								  menuContent.toggleClass('openMenu');
								  menuContent.find('ul').removeClass('openSubMenu');		
								  menuContent.find('ul').removeAttr('style');
								  $("span.arrow").removeClass('arrow-down');
								  leftMenuSearch.focus();
											   
									if( responseSearch.is(':visible') ){
											 
											 responseSearch.slideUp('fast');
											 $('#sidebar-menu').slideDown('fast');		
											 $("#leftMenuSearch").val('');
										
										};//if responseSearch
											   
							}); // .leftBarOpenBtn click function
					
				} else {
					
						if ( leftBar.hasClass('push') ) return ;
						openBtn.trigger('click');
						
					}//if !e
				
				mainLayoutTd.click(function(e){
					
						if ( leftBar.hasClass('push') ) openBtn.trigger('click');
					
					}); // mainLayout click
					
				keyControls().leftPanel(panel); //key control
					 
			},// leftPanel
			
		rightPanel : function ( e ){
			
				var openBtn			= $('.rightBarOpenBtn');
				var rightBar		= $('.rightBar');
				var mainLayout		= $('#wrk_main_layout');
				var mainLayoutTd	= $('#wrk_main_layout > section#wrk_main_layout_td');	
			
				if ( !e ){
					
						openBtn.click(function(){  
							if($("#rightBarDiv").hasClass('push') == false)
							{
								var usersPanel = $('div.usersBar').hasClass('usersBarOpen');
									if (usersPanel) $('div.usersBar').removeClass('usersBarOpen');
									var parentUl =  $('ul.acordionUl').children('li').children('div.acordionContent:visible').slideToggle(200) //div.acordionContent'
								rightBar.toggleClass('rightBarOpen push'); 
								/* if($('.mobileMenu').css("display") == "block")$('.mobileMenu').hide(); */
								AjaxPageLoad('index.cfm?fuseaction=objects.rightBarObjects&XmlFuseaction='+XmlFuseact+'&fuseact='+params+'&'+$("#add_to_favorites").serialize(),'tab-content');
							}
							else
							{
								$("#rightBarDiv").removeClass('rightBarOpen push');
								$("ul.tabNav li").removeClass('active');
								$("ul.tabNav li:first").addClass('active');
							}
						});	//.rightBarOpenBtn click function
					
					}else {

							if ( rightBar.hasClass('push') ) return ;
							openBtn.trigger('click');
						
						}//if !e
				
				mainLayoutTd.click(function(e){
					
						if ( rightBar.hasClass('push') )  openBtn.trigger('click');
					
					});// mainLayoutTd click		

			}, // rightPanel
			
		userPanel : function (){

				$('.usersBarOpenBtn').click(function(){
			
					var rightPanel = $('div.rightBar').hasClass('rightBarOpen');
						if (rightPanel) $('div.rightBar').removeClass('rightBarOpen')
								
					$('.usersBar').toggleClass('usersBarOpen push'); 
				});	//.usersBarOpenBtn click function

			}//userPanel	
		
		}//return

	};//openPanel
		
var openMenus = function (){
	
	return {
		
		settingMenus : function (){
			
				$('ul.acordionUl li.menuAcordion  a').click(function( e ){	
				
					var currentTarget  = e.currentTarget
					var parentUl =  $(this).closest('ul.acordionUl');				
					var openedEl = parentUl.children('li').children('div.acordionContent:visible') //div.acordionContent'
					var nextEl = $(this).next('div.acordionContent');
					
						openedEl.each(function(key,val){
					
								if ( $(val).prev('a')[0] != currentTarget ) $(val).slideToggle(200);	
							
							});// each openedEl
							
						nextEl.slideToggle(200);		
				});//ul.acordionUl li.menuAcordion  a click function
			
			}, //settingMenus
			
		treeMenu : function (){
			
				var menuContent = $('.menu-content');
				
				$('.menu-content li a').click(function(){	
							
					if( menuContent.hasClass('openMenu') ){			
						
						var subMenu = $(this).next('ul.sub-menu');								
							subMenu.slideToggle('fast','swing',function(){
								subMenu.toggleClass('openSubMenu');
								 
								 var __icon = $(this).parent('li').children('a').children('span:last');
								 if ( __icon.hasClass('arrow') ) __icon.toggleClass('arrow-down',200); 
								 
								 
								  var parentLi = $( this ).parent('li');
								$('.leftBar ').animate({scrollTop: parentLi.offset().top  },500);
							
							});// subMenu slideToggle
		
					}else if( menuContent.hasClass('closeMenu') && !$(this).parent('li').hasClass('menuItem')){
				
						var subMenu = $(this).next('ul.sub-menu');
							subMenu.slideToggle('fast','swing',function(){
								subMenu.toggleClass('openSubMenu');
								
								var __icon = $(this).parent('li').children('a').children('span:last'); 
								if ( __icon.hasClass('arrow') ) __icon.toggleClass('arrow-down',200); 
								
							});// subMenu slideToggle
						}//if
				});//.menu-content li a click function
				
			} //treeMenu
	
		}//return 
	
	};// openMenus	

var pageTitle = function(txt){
		//console.log (txt); 
		
		if(!txt) txt = ' '; 
		
		var title	=  txt;
		var doc		= $(document);
		
			doc.prop('title', title);	
	}; // pageTitle
