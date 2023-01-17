// global nesneler
var formObjects = {};  // formObjects

var pageObjects = {};  // formObjects


/**
	sortElement			: Page Designer Giydirir
	positionJsonParse	:
	shiftElement		: Arayüz Giydirir
	updateObject		:
	sortObject			: system modaldaki form değerlerini doldurur post işlemi yapılır
	columnSettings		:
**/



var sortElement = function (controllerName, eventList, settings, returnDefaultValue, recordEmp, recordDate ) { // Page Designer Giydirir
		
		var columnName		= 'column',
			modalId			= 'formPanel',
			editId			= 'frmEdit',
			handle	        = 'form-group',
			sorter			= 'sorter',
			modal 			= $('*').find('div#' + modalId ),
			modalHeader		= modal.find('.modal-header'),
			modalBody		= modal.find('.modal-body'),
			modalFooter		= modal.find('.modal-footer'),
			editTab			= modal.find('#' + editId),
			object 			= formObjects.all,
			objectColumn 	= formObjects.column,
			elControl		= settings,
			colmClass,div;
			
			$("select#pageType").val(formObjects.column.pageType);
			$("select#pageType_screen").val(formObjects.column.pageType_screen);
			$(editTab).html('');
	
		var sortableSettings = {
						
					column	: {
						
							connectWith		: '.' + sorter,
							handle			: '.handle',
							cursor			: 'move',
							opacity			: '0.6',
							placeholder		: 'form-group-corner-all',
							revert			: 300
							
						},
						
					row 	: {
						  
						connectWith		: 'div[type="rowSort"]',
						handle			: '.sorterHead',
						items			: 'div[type="columnSort"]',
						cursor			: 'move',
						opacity			: '0.6',
						placeholder		: 'row-group-corner-all',
						revert			: 300
						
						  }	
						  
				}; // sortableSettings
				
		var columnOptions = { 
					1:	'col col-1', 
					2:	'col col-2', 
					3:	'col col-3', 
					4:	'col col-4', 
					5:	'col col-5', 
					6:	'col col-6', 
					7:	'col col-7', 
					8:	'col col-8', 
					9:	'col col-9', 
					10:	'col col-10', 
					11:	'col col-11', 
					12:'col col-12'
				 }; // columnOptions

			
		var rows	= $('div[type="row"]');
		

		if(returnDefaultValue)
		{
			$("#"+editId+'Ex i.hide').removeClass('hide');
			$("#"+editId+'Ex input.hide').removeClass('hide');
		}
		
		if(recordEmp)
		{
			$("div.recordEmp").text(recordEmp);
			$("div.recordDate").text(recordDate);
		}
		$.each(rows, function(k){
				
				var row 		= $(this),
					column		= row.find('div[type="column"]'),
					rowCount	= k,
					slideBox	= $(this).attr('slideBox'),
					attr		= {},
					input;
				$.extend(attr,{type: 'rowSort'});
				if ( slideBox ){

					var label = $(this).parent('div').prev('div.catalyst-seperator').find('label');
					
					$.extend(attr,{ 'slideBoxSort': true });

					inputTitleArr = objectColumn.pageDesign.filter((el) => { return el.rowCount == rowCount });
					input = $('<div class="form-group"><div class="input-group"><input name="head" id="head" type="text" placeholder="Row Name" value="'+inputTitleArr[0].slideBoxName+'"><input type="hidden" name="dictionary_id" id="dictionary_id"><span class="input-group-addon icon-ellipsis btnPointer"></span></div>');
					
				} // if
				
				$('<div id="item'+rowCount+'" indis='+rowCount+'>')
					.addClass('row')
					.attr(attr)
					.append(
							$('<div>')
								.addClass('col col-12 col-md-12 col-sm-12 col-xs-12 ui-form-list flex-list')
								.attr('type','slideBoxName')
								.append($('<input>').attr({'type' : 'checkbox' , 'onChange' : 'columnSettings("makeSlideBox",null,this)'}).prop('checked',slideBox), input)
								)	
					.appendTo(editTab)
					.sortable(sortableSettings.row);	

					if(formObjects.column.pageType == "step"){
						$('#item'+rowCount+' '+'.pull-right .input-group input').val($('ul.nav-step li').eq(rowCount).find('a > i').text());
					}
					else if(formObjects.column.pageType == "tabs"){
						$('#item'+rowCount+' '+'.pull-right .input-group input').val($('ul.nav-basket li').eq(rowCount).find('a').text());
					}
					else{
						var label = $(this).parent('div').prev('div.catalyst-seperator').find('label');
						$('#item'+rowCount+' '+'.pull-right .input-group input').val(label.text());
					}
					var inc = rowCount + 1;
					$('#item'+rowCount+' '+'.input-group').find('.input-group-addon').attr("onClick", 'windowopen(\'index.cfm?fuseaction=settings.popup_list_lang_settings&is_use_send&lang_dictionary_id=formBuilder[0].dictionary_id['+inc+']&lang_item_name=formBuilder[0].head['+inc+']\',\'list\');return false;');
					
					
				$.each(column,function(){
						
						var elements	= $(this).find('> div.' + handle ),
							sortStatus	= $(this).attr('sort'),
							index       = parseInt( $(this).attr('index')),
							fixedTitle  = $(this).attr("fixedTitle"),
							columnClass	= $(this).attr('class').split(' ');

							
							
						 	if($(this).attr("fixedTitle") != undefined){
								if(index == 22){
							
									var items = $(this).find('.form-group');
			   
									if(formObjects.column.pageDesign.length > 0){
									   $.each(items, function(i){
										   var itemsId = $(this).attr("id");
										   $.each($('#sepetim_total > .col'), function(j){
											   if(itemsId == $(this).attr("id")){
												   $(this).css("order", i+1);
											   }
											});
										});
									}
									
	   
								   $('<div>')
								   .addClass( [ columnClass[0], columnClass[1], columnClass[2], columnClass[3], columnClass[4]].join(' ') )
								   .removeClass("mb-0")
								   .attr({
									   'type' :'columnSort',
									   'index' : index
									   })
								   .append(function(){
									   
										   var div = this;
	   
										   $('<div>')
											   .addClass('sorterHead')
											   .append(
													   $('<span>').addClass('pull-left sorterElementName').append(fixedTitle + '<i style="margin-left:5px;line-height:18px;" title="'+fixedTitle+' içerisine alan ekleme ve çıkarma işlemleriniz için basket yapısı sekmesini kullanabilirsiniz." class="fa fa-info-circle" aria-hidden="true"></i>'),
													   $('<div>').addClass('pull-right sorterPermissionIcon')
														   .append(
															   $('<div>').addClass('colNumber')
																   .append(
																   
																	   $('<select>')
																		   .attr('onChange', 'columnSettings("columnChange",null,this)')
																		   .append(function() {
																				   
																				   var selectBox = this;
																				   
																				   $.each(columnOptions,function(k,v){
																					   
																						   var selected;	
																						   ( String(v)  === String( [ columnClass[0], columnClass[1]].join(' ') ) ) ? selected = true : selected = false;
																					   
																						   $('<option>').val(v).text(k).prop('selected',selected).appendTo(selectBox);	
																					   
																					   });
																		   })
																   
																   ),
															   $('<i>').addClass('icon-eye-slash').attr('title', language.aktif),
															   //$('<i>').addClass('icon-asterisk').attr('title', language.zorunlu),
															   //$('<i>').addClass('icon-lock').attr('title', language.sadeceOkunur),																		
															   $('<i>').addClass('icon-phone').attr('title', 'mobilde gizle').attr('style', 'font-size: 16px'),																		
															   $('<i>').addClass('icon-cogs')
														   )
												   )
											   .appendTo(div);
											   if ( eval( sortStatus ) ){
		   
												   $('<ul>')
													   .addClass( sorter )
													   .append(function(){
													   
														   var ul = this ;
												   
														   $.each(elements, function (key,val) {
																   
															   var _el				= $(val),
																   divId			= _el.attr('id'),
																   divLabel		= _el.find('label:first').text(),			 		 			
																   SettingClick	= "modalDesigner('" + divId + "')",
																   refreshClick	= "modalDesigner('" + divId+ " ','ref')",
																   visb, read, req, visible, require, readonly, positionIcon, mobile;
	   
																   
	   
															   var	control = $.grep(object, function (v){ if (v.item){ return v.item.data === divId; }else{ return; } });
																   
															   if ( control.length > 0 ) {
																   
																	   visb =  control[0].item.visb; read =  control[0].item.read; req  =  control[0].item.req ; mobile = control[0].item.mobile ;
																   
																   } else {
																		   visb =  false; read =  false; req  =  false; mobile = false;
																	   } // if control
																	   
															   if ( elControl.indexOf(divId) == -1 ) {
																   
																	   visible		 = $('<input>').attr( { type : 'checkbox', id : 'visible', onClick  : refreshClick, title : 'Aktif/Pasif'} ).prop('checked', visb ); 
																	   require		 = $('<input>').attr( { type : 'checkbox', id : 'require', onClick  : refreshClick, title : 'Zorunludur' } ).prop('checked', req );
																	   
																   }else {
																	   visible = '';
																	   require = '';
																	   
																   }// if elControl
																   
																   readonly	 = $('<input>').attr( { type : 'checkbox', id : 'readonly', onClick  : refreshClick, title : 'Sadece Okunur'} ).prop('checked', read ); 
																   mobilevis	 = $('<input>').attr( { type : 'checkbox', id : 'mobile', onClick : refreshClick, title : 'Mobilde Gizle' }).prop('checked', mobile);
																   positionIcon = $('<i>').addClass('fa fa-cog').attr('onClick' ,SettingClick);
																   
																			   
																   if(divLabel.length){
																	   $('<li>')
																	   .attr( 'item',divId )
																	   .append( 
																			   $('<div>')
																				   .addClass('row')
																				   .append(
																					   $('<span>').addClass('pull-left sorterElementName handle').append( divLabel ),
																					   $('<span>').addClass('pull-right sorterElementPermission').append( visible, mobilevis, positionIcon )
																				   ),
																			   $('<div>').addClass('row SettingsBox scroll-sm').attr('id' , divId + '-SettingsBox' )
																		   )
																	   .appendTo( ul );
																   }
				   
															   }); // each 
													   })
													   .appendTo(div)
													   .sortable();
								   
												   }else {
													   
														   $('<ul>').addClass('pa').append( $('<li>').addClass('not-Sortable').append(language.BuKolonDuzenlenemez)).appendTo(div);
				   
													   }//if
									   })
								   .appendTo(editTab.find('div[type="rowSort"]').eq(rowCount));
								}
								else if(index == 20 || index == 21){
								   $('<div>')
								   .addClass( [ columnClass[0], columnClass[1], columnClass[2], columnClass[3], columnClass[4]].join(' ') )
								   .attr({
									   'type' :'columnSort',
									   'index' : index
									   })
								   .append(function(){
									   
										   var div = this;
	   
										   $('<div>')
											   .addClass('sorterHead')
											   .append(
													   $('<span>').addClass('pull-left sorterElementName').append(fixedTitle),
													   $('<div>').addClass('pull-right sorterPermissionIcon')
														   .append(
															   $('<div>').addClass('colNumber')
																   .append(
																   
																	   $('<select>')
																		   .attr('onChange', 'columnSettings("columnChange",null,this)')
																		   .append(function() {
																				   
																				   var selectBox = this;
																				   
																				   $.each(columnOptions,function(k,v){
																					   
																						   var selected;	
																						   ( String(v)  === String( [ columnClass[0], columnClass[1]].join(' ') ) ) ? selected = true : selected = false;
																					   
																						   $('<option>').val(v).text(k).prop('selected',selected).appendTo(selectBox);	
																					   
																					   });
																		   })
																   
																   )
															   //,$('<i>').addClass('icon-eye-slash').attr('title', language.aktif),
															   //$('<i>').addClass('icon-asterisk').attr('title', language.zorunlu),
															   //$('<i>').addClass('icon-lock').attr('title', language.sadeceOkunur),																		
															   //$('<i>').addClass('icon-phone').attr('title', 'mobilde gizle').attr('style', 'font-size: 16px'),																		
															   //$('<i>').addClass('icon-cogs')
														   )
												   )
											   .appendTo(div);
											   if ( eval( sortStatus ) ){
		   
												   $('<ul>')
													   .addClass( sorter )
													   .append(function(){
													   
														   var ul = this ;
												   
														   $.each(elements, function (key,val) {
																   //console.log (val);
																   
																   var _el				= $(val),
																	   divId			= _el.attr('id'),
																	   divLabel		= _el.find('label:first').text(),			 		 			
																	   SettingClick	= "modalDesigner('" + divId + "')",
																	   refreshClick	= "modalDesigner('" + divId+ " ','ref')",
																	   visb, read, req, visible, require, readonly, positionIcon, mobile;
																			   
																   $('<li>')
																	   .attr( 'item',divId )
																	   .append( 
																			   $('<div>')
																				   .addClass('row')
																				   .append(
																					   $('<span>').addClass('pull-left sorterElementName handle').append( divLabel ),
																				   ),
																			   $('<div>').addClass('row SettingsBox scroll-sm').attr('id' , divId + '-SettingsBox' )
																		   )
																	   .appendTo( ul );
				   
															   }); // each 
													   })
													   .appendTo(div)
													   .sortable(sortableSettings.column);
								   
												   }else {
	   
														   $('<ul>').addClass('pa').append( $('<li>').addClass('not-Sortable').append(language.edit_basket_designer)).appendTo(div);
														   
													   }//if
									   })
								   .appendTo(editTab.find('div[type="rowSort"]').eq(rowCount));
								}
							 }
							 else{
								$('<div>')
								.addClass( [ columnClass[0], columnClass[1], columnClass[2], columnClass[3], columnClass[4]].join(' ') )
								.attr({
									'type' :'columnSort',
									'index' : index
									})
								.append(function(){
									
										var div = this;
	
										$('<div>')
											.addClass('sorterHead')
											.append(
													$('<span>').addClass('pull-left sorterElementName').append(language.kolon + ' ' + index ),
													$('<div>').addClass('pull-right sorterPermissionIcon')
														.append(
															$('<div>').addClass('colNumber')
																.append(
																
																	$('<select>')
																		.attr('onChange', 'columnSettings("columnChange",null,this)')
																		.append(function() {
																				
																				var selectBox = this;
																				
																				$.each(columnOptions,function(k,v){
																					
																						var selected;	
																						( String(v)  === String( [ columnClass[0], columnClass[1]].join(' ') ) ) ? selected = true : selected = false;
																					
																						$('<option>').val(v).text(k).prop('selected',selected).appendTo(selectBox);	
																					
																					});
																		})
																
																),
															$('<i>').addClass('icon-eye-slash').attr('title', language.aktif),
															$('<i>').addClass('icon-asterisk').attr('title', language.zorunlu),
															$('<i>').addClass('icon-lock').attr('title', language.sadeceOkunur),																		
															$('<i>').addClass('icon-phone').attr('title', 'mobilde gizle').attr('style', 'font-size: 16px'),																		
															$('<i>').addClass('icon-cogs')
														)
												)
											.appendTo(div);
																				
										if ( eval( sortStatus ) ){
		
											$('<ul>')
												.addClass( sorter )
												.append(function(){
												
													var ul = this ;
											
													$.each(elements, function (key,val) {
															//console.log (val);
															
															var _el				= $(val),
																divId			= _el.attr('id'),
																divLabel		= _el.find('label:first').text(),			 		 			
																SettingClick	= "modalDesigner('" + divId + "')",
																refreshClick	= "modalDesigner('" + divId+ " ','ref')",
																visb, read, req, visible, require, readonly, positionIcon, mobile;
																
															var	control = $.grep(object, function (v){ if (v.item){ return v.item.data === divId; }else{ return; } });
																
															if ( control.length > 0 ) {
																
																	visb =  control[0].item.visb; read =  control[0].item.read; req  =  control[0].item.req ; mobile = control[0].item.mobile ;
																
																} else {
																		visb =  false; read =  false; req  =  false; mobile = false;
																	} // if control
																	
															if ( elControl.indexOf(divId) == -1 ) {
																
																	visible		 = $('<input>').attr( { type : 'checkbox', id : 'visible', onClick  : refreshClick, title : 'Aktif/Pasif'} ).prop('checked', visb ); 
																	require		 = $('<input>').attr( { type : 'checkbox', id : 'require', onClick  : refreshClick, title : 'Zorunludur'} ).prop('checked', req );
																	
																}else {
																	visible = '';
																	require = '';
																	
																}// if elControl
																
																readonly	 = $('<input>').attr( { type : 'checkbox', id : 'readonly', onClick  : refreshClick, title : 'Sadece Okunur'} ).prop('checked', read ); 
																mobilevis	 = $('<input>').attr( { type : 'checkbox', id : 'mobile', onClick : refreshClick, title : 'Mobilde Gizle'}).prop('checked', mobile);
																positionIcon = $('<i>').addClass('fa fa-cog').attr('onClick' ,SettingClick);
																			
															$('<li>')
																.attr( 'item',divId )
																.append( 
																		$('<div>')
																			.addClass('row')
																			.append(
																				$('<span>').addClass('pull-left sorterElementName handle').append( divLabel ),
																				$('<span>').addClass('pull-right sorterElementPermission').append( visible, require, readonly, mobilevis, positionIcon )
																			),
																		$('<div>').addClass('row SettingsBox scroll-sm').attr('id' , divId + '-SettingsBox' )
																	)
																.appendTo( ul );
			
														}); // each 
												})
												.appendTo(div)
												.sortable(sortableSettings.column);
							
											}else {
												
													$('<ul>').append( $('<li>').addClass('not-Sortable').append(language.BuKolonDuzenlenemez)).appendTo(div);
			
												}//if
								
									})
								.appendTo(editTab.find('div[type="rowSort"]').eq(rowCount));
							}
							
					}); //each	
					
			
			}); // each
	
		var clickFunction = 'sortObject(\''+controllerName+'\',\''+eventList+'\')';
		
		$("#actionButtonNew").attr('onClick',clickFunction);
		editTab.parent('form').find('div.modal-footer input#actionButton').attr('onClick',clickFunction);
		$('.tabsLink').click(function(){
			$('ul.tabNav > li:nth-child(2) > a').trigger("click");
		});
				
	}; // sorttElement	

var positionJsonParse = function ( data ){
		
		
		var data = $.parseJSON(data);
		
		$.each(data, function (k,v){
				//console.log(k,v)
				
				formObjects[k] = v; 
				
			}); // each data
			
			if($('.uniqueBox  div[data-basket="1"] #basketIframe').length == 0 && $('.uniqueBox  div[data-basket="1"] .pod_basket').length == 0){
				if($('#basketIframe').length != 0){
					if($('#item0').length == 0){
						$('div[type="row"]').eq(0).append('<div id="searchBasket" style="display:none;" class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="20" fixedTitle="Search Bar"><div class="form-group"></div></div>');
						$('div[type="row"]').eq(0).append('<div style="display:none;" class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="21" fixedTitle="Basket Bar"><div class="form-group"></div></div>');
						$('div[type="row"]').eq(0).append('<div id="totalBasket" style="display:none;" class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="22" fixedTitle="Total Bar"><div class="form-group"></div></div>');
					}
				}
				else if($('.pod_basket').length != 0){
						$('div[type="row"]').eq(0).append('<div style="display:none;" class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="21" fixedTitle="Basket Bar"><div class="form-group"></div></div>');
						$('div[type="row"]').eq(0).append('<div id="totalBasket" style="display:none;" class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="22" fixedTitle="Total Bar"><div class="form-group"></div></div>');
				}
				$.each($('.totalBoxHead .headText'), function(i){
					let text = $(this).text();
					text = text.trim();
					text = text.replace(" ", "_");
					text = text.replace("ö", "o").replace("Ö", "o").replace("ü","u").replace("Ü","u").replace("ğ","g").replace("Ğ","g").replace("ş","s").replace("Ş","s").replace("ç","c").replace("Ç","c").replace("İ","i").replace("I","i").replace("ı","i");
					text = text.toLowerCase();
					$(this).parent().parent().parent().attr("id", 'item-' + text);
					$('#totalBasket').append('<div style="display:none" class="form-group" id="item-'+text+'"><label>'+$(this).text()+'</label></div>');
				});
			}

	};// positionJsonParse

var shiftElement = function ( pstId, settings, userPstId, screenType ){ //Arayüz giydirme
		//console.log(pstId,settings,userPstId);
		"use strict";	
			var objectAll		= formObjects.all,
				objectPst		= formObjects.positions,
				objectColumn	= formObjects.column.pageDesign,
				objectPageType  = formObjects.column.pageType,
				objectPageTypeScreen = ( screenType != '') ? screenType : formObjects.column.pageType_screen,
				columnName		= 'column',
				sOHandle		= 'systemObject', // system Object Handle
				eFHandle		= 'extendedFields', // extended Fields handle
				handle			= '.form-group',
				elSel			= 'input:visible, select:visible, textarea:visible , select.multiSelect, span, button, i,textarea,input,select',
				sObject			= $('div[type="'+ sOHandle +'"]').find('div' + handle ),
				eFields			= $('div[type="'+ eFHandle +'"]').find('div' + handle ),
				firstColumn		= $( 'div[type="'+ columnName +'"][sort="true"]:first' ),
				lastColumn		= $( 'div[type="'+ columnName +'"][sort="true"]:last' );
				
			//firstColumn.prepend(sObject);
			//lastColumn.append(eFields);
			if(objectPageType == ""){	
				$.each(objectColumn, function (){
					
					var row				= $('div[type="row"]').eq(this.rowCount),
						standardClass 	= 'col-md-4 col-sm-12';
				
					if (row.length === 0 ) {
									if  ($('div[type="row"]:last').parent('div').hasClass('row') ) {
										
												$('div[type="row"]:last').after($('<div>').addClass('row').attr('type', 'row'));
										
										}else{
											
												$('div[type="row"]:last').parent('div').after($('<div>').addClass('row').attr('type', 'row'));
											
											} // if
							
	
								row	= $('div[type="row"]').eq(this.rowCount);
							
							}// if
					
					var column	= $( 'div[type="'+ columnName +'"][index="' + this.index + '"]' );		
					
					if ( column.length === 0 ) {
						$('<div>')
							.addClass($( 'div[type="'+ columnName + '"][index="1"]' ).attr('class'))
							.attr({
								"type" : columnName,
								"index" : this.index,
								"sort" : true,	
								})
							.appendTo(row);	
						
						column	= $( 'div[type="'+ columnName +'"][index="' + this.index + '"]' );	
					
					}// if
					
					column.removeAttr('class').addClass( [ this.class, standardClass ].join(' '));
					row.append(column);
					if ( this.slideBox ){
						
						if ( !row.attr('slideBox') ) {
								if(!row.prev('div').length)
									$("<div>").insertBefore(row);
								var prevElement = row.prev('div');
							
								row.attr('slideBox', true);
							
								if(!prevElement.length)
									$("<div>").appendTo(row);
								/*prevElement.after( 
											$('<div>')
												.addClass('catalyst-seperator')
												.append($('<label>')
													.append($('<i>').addClass("icon-angle-down"))
													.append(this.slideBoxName)												
													.attr('onClick','slideBoxToggle(this)')),
											$('<div>').append(row)
										);*/
							
							} // if
					
					} // if		
				
				});

				var htmlDesign = $('.ui-form-list > div[type="column"]');
				$.each(htmlDesign, function(){

					var attr = $(this).attr("fixedTitle"),
					htmlDesignIndex, htmlDesignTitle, htmlDesignItem, htmlDesignFilter;

					if($(this).attr("index") == 20 || $(this).attr("index") == 21 || $(this).attr("index") == 22){
						$(this).show();
						$(this).find('.form-group').hide();
					}
					
					if(typeof attr != "undefined"){
						
						htmlDesignIndex = $(this).parent().attr("index");
						htmlDesignTitle = $(this).attr("fixedTitle");

						if($('.pod_basket').length == 0){
							htmlDesignFilter = $('div#basket_main_div');
							
							var searchBarElem = htmlDesignFilter.find('#basketIframe');
							var basketBarElem = htmlDesignFilter.find('#basketBox');
							var toplamBar = htmlDesignFilter.find('#sepetim_total_table_tutar_tr');
						}
						else{
							var basketBarElem = $('.pod_basket');
						
							var toplamBar = $('#sepetim_total');
							
						}

						if(htmlDesignTitle == "Search Bar"){
							$(this).addClass("mb-0");
							if($('.nav-basket-content').find(searchBarElem).length == 0){
							//if($('div#basket_main_div .ui-form-list').find(searchBarElem).length == 0){
								$('div[basket-content]').append(searchBarElem);
							}
						}

						if(htmlDesignTitle == "Basket Bar"){
							if($('.nav-basket-content').find(basketBarElem).length == 0){
							//if($('.div#basket_main_div .ui-form-list').find(basketBarElem).length == 0){
								//$("#sepet_table").remove();
								$('div[basket-content]').append(
									$("<div>").attr({"id": "sepet_table"}).append(
										$("<div>").attr({"id":"basket_tr"}).append(basketBarElem)
									)
								)
							}
						}

						if(htmlDesignTitle == "Total Bar"){
							if($('.nav-basket-content').find(toplamBar).length == 0){
							//if($('.div#basket_main_div .ui-form-list').find(toplamBar).length == 0){
								$('div[basket-content]').append(toplamBar);
							}
						}

					}
					
				});

				
				if($('#basketIframe').length || $('.pod_basket').length){
					$('.formContentFooter').hide();
					$.each($('.nav-basket-content'), function(i){
						var elControl = $('.formContentFooter');
						if($('.nav-basket-content').eq(i).find('.form-group input').length != 0){
							$('.nav-basket-content').eq(i).append(elControl.html());
							
						}
					})
					
					if($(window).width() < 767){
						$('.row .uniqueRow > .row').find('.formContentFooter').remove();
					}
						
				}

			}
			else if(objectPageType == "accordion"){	
				if( objectPageTypeScreen == "" || $(window).width() > 767 && objectPageTypeScreen == "desktop" || (objectPageTypeScreen == "mobile" && $(window).width() < 767) ){
					$.each(objectColumn, function (){
					
						var row				= $('div[type="row"]').eq(this.rowCount),
							standardClass 	= 'col-md-4 col-sm-12';
					
						if (row.length === 0 ) {
									if  ($('div[type="row"]:last').parent('div').hasClass('row') ) {
										
												$('div[type="row"]:last').after($('<div>').addClass('ui-form-list row').attr('type', 'row'));
										
										}else{
											
												$('div[type="row"]:last').parent('div').after($('<div>').addClass('ui-form-list row').attr('type', 'row'));
											
											} // if
								
		
									row	= $('div[type="row"]').eq(this.rowCount);
								
								}// if
						
						var column	= $( 'div[type="'+ columnName +'"][index="' + this.index + '"]' );		
						
						if ( column.length === 0 ) {
									$('<div>')
										.addClass($( 'div[type="'+ columnName + '"][index="1"]' ).attr('class'))
										.attr({
											"type" : columnName,
											"index" : this.index,
											"sort" : true,	
											})
										.appendTo(row);	
									
									column	= $( 'div[type="'+ columnName +'"][index="' + this.index + '"]' );	
								
								}// if
						
						column.removeAttr('class').addClass( [ this.class, standardClass ].join(' '));
						row.append(column);
						
						if ( this.slideBox ){
							
								if ( !row.attr('slideBox') ) {
										if(!row.prev('div').length)
											$("<div>").insertBefore(row);
										var prevElement = row.prev('div');
									
										row.attr('slideBox', true);
									
										if(!prevElement.length)
											$("<div>").appendTo(row);
										prevElement.after( 
													$('<div>')
														.addClass('catalyst-seperator')
														.append($('<label>')
															.append($('<i>').addClass("icon-angle-right"))
															.append(this.slideBoxName)												
															.attr('onClick','slideBoxToggle(this)')),
													$('<div class="nav-accordion-content">').append(row)
												);
												
									
									} // if
							
							} // if		
					
					});

					var htmlDesign = $('.ui-form-list > div[type="column"]');
					$.each(htmlDesign, function(){

						var attr = $(this).attr("fixedTitle"),
						htmlDesignIndex, htmlDesignTitle, htmlDesignItem, htmlDesignFilter;
						
						if($(this).attr("index") == 20 || $(this).attr("index") == 21 || $(this).attr("index") == 22){
							$(this).show();
							$(this).find('.form-group').hide();
						}

						if(typeof attr != "undefined"){
							htmlDesignIndex = $(this).parent().attr("index");
							htmlDesignTitle = $(this).attr("fixedTitle");

							if($('.pod_basket').length == 0){
								htmlDesignFilter = $('div#basket_main_div');
							
								/* if($('#newPortBox').length == 0){
									$('ul.nav-basket').after('<div id="newPortBox">'+htmlDesignFilter.html()+'</div>');
									$('#newPortBox').find("#basketIframe").remove();
									$('#newPortBox').find("#sepet_table").remove();
								} */

								var searchBarElem = htmlDesignFilter.find('#basketIframe');
								var basketBarElem = htmlDesignFilter.find('#basketBox');
								var toplamBar = htmlDesignFilter.find('#sepetim_total_table_tutar_tr');
							}
							else{
								var basketBarElem = $('.pod_basket');
							
								var toplamBar = $('#sepetim_total');
								
							}

							if(htmlDesignTitle == "Search Bar"){
								$(this).addClass("mb-0");
								if($('.nav-accordion-content').find(searchBarElem).length == 0){
									$('div[basket-content]')(searchBarElem);
								}
							}

							if(htmlDesignTitle == "Basket Bar"){
								if($('.nav-accordion-content').find(basketBarElem).length == 0){
									$('div[basket-content]').append(
										$("<div>").attr({"id": "sepet_table"}).append(
											$("<div>").attr({"id":"basket_tr"}).append(basketBarElem)
										)
									)
								}
							}

							if(htmlDesignTitle == "Total Bar"){
								if($('.nav-accordion-content').find(toplamBar).length == 0){
									$('div[basket-content]').append(toplamBar);
								}
							}

						}
						
					});
				}
				
			}
			else if(objectPageType == "tabs"){
				if( objectPageTypeScreen == "" || ( $(window).width() > 767 && objectPageTypeScreen == "desktop" ) || (objectPageTypeScreen == "mobile" && $(window).width() < 767) ){
					/* if($(window).width() < 767){
						var rw = $('div[type="row"]').parent().parent();
						rw.prepend('<ul class="nav nav-tabs nav-basket"></ul>');
					}
					else{ */
						var rw = $('div[type="row"]').parent();
						rw.prepend('<ul class="nav nav-tabs nav-basket"></ul>');
					/* } */
				
					var copyObjectRowCount = [];
				
					$.each(objectColumn, function (){
						if(copyObjectRowCount.indexOf(this.rowCount) == -1){
							copyObjectRowCount.push(this.rowCount);
							$('ul.nav-tabs').append('<li><a href="javascript:;" class="tablinks" toggle="tab'+this.rowCount+'">'+this.slideBoxName+'</a></li>');
						}
						var row				= $('div[type="row"]').eq(this.rowCount),
							standardClass 	= 'col-md-4 col-sm-12';
					
						if (row.length === 0 ) {
							if($('.big_list_search_detail_area').length > 0){
								if  ($('div[type="row"]:last').parent('div').hasClass('row') ) {
										
									$('div[type="row"]:last').append($('<div>').addClass('row').attr('type', 'row'));
							
								}else{
								
									$('div[type="row"]:last').parent('div').append($('<div>').addClass('row').attr('type', 'row'));
								
								}
							}
							else{
								if  ($('div[type="row"]:last').parent('div').hasClass('row') ) {
										
									$('div[type="row"]:last').append($('<div>').addClass('ui-form-list row').attr('type', 'row'));
							
								}else{
								
									$('div[type="row"]:last').parent('div').append($('<div>').addClass('ui-form-list row').attr('type', 'row'));
								
								}
							}
									// if
								
		
							row	= $('div[type="row"]').eq(this.rowCount);
						
						}// if
						
						var column	= $( 'div[type="'+ columnName +'"][index="' + this.index + '"]' );		
						
						if ( column.length === 0 ) {
									$('<div>')
										.addClass($( 'div[type="'+ columnName + '"][index="1"]' ).attr('class'))
										.attr({
											"type" : columnName,
											"index" : this.index,
											"sort" : true,	
											})
										.appendTo(row);	
									
									column	= $( 'div[type="'+ columnName +'"][index="' + this.index + '"]' );	
								
								}// if
						
						column.removeAttr('class').addClass( [ this.class, standardClass ].join(' '));
						row.append(column);
						
						if ( this.slideBox ){
							
								if ( !row.attr('slideBox') ) {
										
									var prevElement = row.prev('div');
								
									row.attr({
										'slideBox': true,
										'index' : this.index - 1
									}).addClass('nav-basket-content');
								
									if(!prevElement.length)
										$("<div>").appendTo(row);
								
								} // if
						
						} // if		
					
					});

					var htmlDesign = $('.ui-form-list > div[type="column"]');
					$.each(htmlDesign, function(){

						var attr = $(this).attr("fixedTitle"),
						htmlDesignIndex, htmlDesignTitle, htmlDesignItem, htmlDesignFilter;

						if($(this).attr("index") == 20 || $(this).attr("index") == 21 || $(this).attr("index") == 22){
							$(this).show();
							$(this).find('.form-group').hide();
						}
						
						if(typeof attr != "undefined"){
							
							htmlDesignIndex = $(this).parent().attr("index");
							htmlDesignTitle = $(this).attr("fixedTitle");

							if($('.pod_basket').length == 0){
								htmlDesignFilter = $('div#basket_main_div');

								var searchBarElem = htmlDesignFilter.find('#basketIframe');
								var basketBarElem = htmlDesignFilter.find('#basketBox');
								var toplamBar = htmlDesignFilter.find('#sepetim_total_table_tutar_tr');
							}
							else{
								var basketBarElem = $('.pod_basket');
							
								var toplamBar = $('#sepetim_total');
								
							}

							if(htmlDesignTitle == "Search Bar"){
								$(this).addClass("mb-0");
								if($('.nav-basket-content').find(searchBarElem).length == 0){
									$('div[basket-content]').append(searchBarElem);
								}
							}

							if(htmlDesignTitle == "Basket Bar"){
								if($('.nav-basket-content').find(basketBarElem).length == 0){
									$('div[basket-content]').append(
										$("<div>").attr({"id": "sepet_table"}).append(
											$("<div>").attr({"id":"basket_tr"}).append(basketBarElem)
										)
									)
								}
							}

							if(htmlDesignTitle == "Total Bar"){
								if($('.nav-basket-content').find(toplamBar).length == 0){
									$('div[basket-content]').append(toplamBar);
								}
							}

						}
						
					});

					
					if($('#basketIframe').length || $('.pod_basket').length){
						$('.formContentFooter').hide();
						$.each($('.nav-basket-content'), function(i){
							var elControl = $('.formContentFooter');
							if($('.nav-basket-content').eq(i).find('.form-group input').length != 0){
								$('.nav-basket-content').eq(i).append(elControl.html());
								
							}
						})
						
						if($(window).width() < 767){
							$('.row .uniqueRow > .row').find('.formContentFooter').remove();
						}
							
					}

					$('.nav-basket li').eq(0).addClass("active"); // Tab Active Element
					$('.nav-basket-content').hide();
					$('.nav-basket-content').eq(0).css({"display":"flex"});
					$('.nav-basket li').click(function(){ // Tab Click Event
						//if($(window).width() > 767){
							var clickTab = $(this).find('a').attr("toggle");
							$(this).prevAll().removeClass("active");
							$(this).nextAll().removeClass("active");
							$(this).addClass("active");
							$('.nav-basket-content').hide();
							$('.nav-basket-content').eq($(this).index()).css({"display":"flex"});
							/* $( "#tblBasket" ).fixedHeaderTable(); */
						//}
					});
				}
						
			}
			else if(objectPageType == "step"){
				if($(window).width() < 767){
					var rw = $('div[type="row"]').parent().parent();
					rw.prepend('<ul class="nav nav-tabs nav-step"></ul>');
				}
				else{
					var rw = $('div[type="row"]').parent();
					rw.prepend('<ul class="nav nav-tabs nav-step"></ul>');
				}
				
				if($('#workcube_button').length > 0){
					$('#workcube_button').parent().append('<div class="stepButton"><div class="bt nextButton" type="ileri">İleri</div><div class="bt prevButton" type="geri">Geri</div></div>');
				}
				else if($('#big_list_search_hr_list_hr_search_div').length > 0){
					$('#big_list_search_hr_list_hr_search_div').append('<div class="stepButton stepBlock"><div class="bt nextButton" type="ileri">İleri</div><div class="bt prevButton" type="geri">Geri</div></div>');
				}

				var copyObjectRowCount = [];
				$.each(objectColumn, function (){
					if(copyObjectRowCount.indexOf(this.rowCount) == -1){
						copyObjectRowCount.push(this.rowCount);
						var rowCount = this.rowCount + 1;
						$('ul.nav-step').append('<li><a href="javascript:;" toggle="step'+this.rowCount+'"><span>'+rowCount+'</span><i>'+this.slideBoxName+'</i></a></li>');
					}
						var row			= $('div[type="row"]').eq(this.rowCount),
						standardClass 	= 'col-md-4 col-sm-12';
				
					if (row.length === 0 ) {
								 if  ($('div[type="row"]:last').parent('div').hasClass('row') ) {
									 
											 $('div[type="row"]:last').append($('<div>').addClass('row').attr('type', 'row'));
									 
									 }else{
										 
											 $('div[type="row"]:last').parent('div').append($('<div>').addClass('row').attr('type', 'row'));
										 
										 } // if
							
	
								row	= $('div[type="row"]').eq(this.rowCount);
							
							}// if
					
					var column	= $( 'div[type="'+ columnName +'"][index="' + this.index + '"]' );		
					
					if ( column.length === 0 ) {
								$('<div>')
									.addClass($( 'div[type="'+ columnName + '"][index="1"]' ).attr('class'))
									.attr({
										"type" : columnName,
										"index" : this.index,
										"sort" : true,	
										})
									.appendTo(row);	
								
								column	= $( 'div[type="'+ columnName +'"][index="' + this.index + '"]' );	
							
							}// if
					
					column.removeAttr('class').addClass( [ this.class, standardClass ].join(' '));
					row.append(column);
					
					if ( this.slideBox ){
						
							if ( !row.attr('slideBox') ) {
									
									var prevElement = row.prev('div');
								
									row.attr({
										'slideBox': true,
										'class' : 'nav-step-content',
									});
								
									if(!prevElement.length)
										$("<div>").appendTo(row);
									/*prevElement.after( 
												$('<div>')
													.addClass('catalyst-seperator')
													.append($('<label>')
														.append($('<i>').addClass("icon-angle-down"))
														.append(this.slideBoxName)												
														.attr('onClick','slideBoxToggle(this)')),
												$('<div>').append(row)
											);*/
								
								} // if
						
						} // if		
				
				});

				var htmlDesign = $('.ui-form-list > > div[type="column"]');
				$.each(htmlDesign, function(){

					var attr = $(this).attr("fixedTitle"),
					htmlDesignIndex, htmlDesignTitle, htmlDesignItem, htmlDesignFilter;

					if($(this).attr("index") == 20 || $(this).attr("index") == 21 || $(this).attr("index") == 22){
						$(this).show();
						$(this).find('.form-group').hide();
					}

					if(typeof attr != "undefined"){
						htmlDesignIndex = $(this).parent().attr("index");
						htmlDesignTitle = $(this).attr("fixedTitle");

						if($('.pod_basket').length == 0){
							htmlDesignFilter = $('div#basket_main_div');
						
							/* if($('#newPortBox').length == 0){
								$('ul.nav-basket').after('<div id="newPortBox">'+htmlDesignFilter.html()+'</div>');
								$('#newPortBox').find("#basketIframe").remove();
								$('#newPortBox').find("#sepet_table").remove();
							} */

							var searchBarElem = htmlDesignFilter.find('#basketIframe');
							var basketBarElem = htmlDesignFilter.find('#basketBox');
							var toplamBar = htmlDesignFilter.find('#sepetim_total_table_tutar_tr');
						}
						else{
							var basketBarElem = $('.pod_basket');
							
							var toplamBar = $('#sepetim_total');
							
						}

						if(htmlDesignTitle == "Search Bar"){
							$(this).addClass("mb-0");
							if($('.nav-step-content').find(searchBarElem).length == 0){
								$('div[basket-content]').append(searchBarElem);
							}
						}

						if(htmlDesignTitle == "Basket Bar"){
							if($('.nav-step-content').find(basketBarElem).length == 0){
								$("#sepet_table").remove();
								$('div[basket-content]').append(
									$("<div>").attr({"id": "sepet_table"}).append(
										$("<div>").attr({"id":"basket_tr"}).append(basketBarElem)
									)
								)
							}
						}

						if(htmlDesignTitle == "Total Bar"){
							if($('.nav-step-content').find(toplamBar).length == 0){
								$('div[basket-content]').append(toplamBar);
							}
						}

					}
					
				});

				if($('#basketIframe').length || $('.pod_basket').length){
					if($(window).width() < 767){
						$.each($('.nav-step-content'), function(i){
							var elControl = $('.formContentFooter');
							if($('.nav-step-content').eq(i).find('.form-group input').length != 0){
								$('.nav-step-content').eq(i).append(elControl.html());
								
							}
						})
						$('.row .uniqueRow > .row').find('.formContentFooter').remove();
					}
						
				}

				  $('.prevButton').hide();
				   $('#workcube_button').hide();
				   $('.nav-step li').eq(0).addClass("active"); // Step Active Element
				   $('.nav-step-content').eq($('.nav-step li.active').index()).css({"display":"flex"});
	
					if($('.nav-step li:last-child').index() == 0){
						$('#workcube_button').show();
						$('.nextButton').hide();
					}

					   $('.bt').click(function(){
		
						var index = $('.nav-step li.active').index();
						var lastIndex = $('.nav-step li:last-child').index();
						   
						   if($(this).attr("type") == "ileri"){
								
								var reqCount = 0;
								var isReq =	$('.nav-step-content').eq(index).find('input, textarea, select');
								$.each(isReq, function(){
									var isAttr = $(this).attr("required");
									
									if(isAttr == "required" && $(this).val() == "" && $(this).css("display") == "inline-block"){
										if($(this).hasClass("border-red-haze")){
											reqCount++;
										}
										else{
											$(this).addClass("border-red-haze");
											/* $(this).parent().append('<span class="font-red-haze pull-right validContent">'+ $(this).parent().parent().find('label').text() +'</span>'); */
											reqCount++;
										}
									}
									else{
										$(this).removeClass("border-red-haze");
										$(this).parent().find('> span.validContent').remove();
									}
								}); 
		
								if(reqCount == 0){
									
									if(index >= 0 && index + 1 <= lastIndex){
										$('.nav-step li.active').removeClass("active");
										$('.nav-step li').eq(index+1).addClass("active");
										$('.prevButton').show();

										

									}
									if(index + 1 == lastIndex){
										$('#workcube_button').show();
										$('.nextButton').hide();
									}
			
									$('.nav-step-content').hide();
									$('.nav-step-content').eq($('.nav-step li.active').index()).show();
									/* $( "#tblBasket" ).fixedHeaderTable(); */
								}
								
						   }
						   else{
		
								$('#workcube_button').hide();
		
								if(index > 0){
									$('.nav-step li.active').removeClass("active");
									$('.nav-step li').eq(index-1).addClass("active");
	
								}
								if(index <= lastIndex){
									$('.nextButton').show();
								}
								if(index -1 == 0){
									$('.prevButton').hide();
								}
								
								$('.nav-step-content').hide();
								$('.nav-step-content').eq($('.nav-step li.active').index()).show();
								/* $( "#tblBasket" ).fixedHeaderTable(); */
								
		
						   }
						   
					   })
							
			}

			$.each(objectAll, function(key,val){
					///console.log (val.item)
										
						var colmn	= val.item.colmn,
							id		= val.item.data,
							visb	= val.item.visb,
							req		= val.item.req,
							read	= val.item.read,
							mobile	= undefined
							;
							
						if (val.item.mobile !== undefined) mobile	= val.item.mobile;
							
					var	columnPanel	= $( 'div[type="'+ columnName +'"][index="' + colmn + '"]' ), el;
					
					el	= $('#'+ id);
					

					$( el ).find(elSel).prop('readonly', read);
					
					if(read)
						$( el ).find(elSel).attr('disabledElement',1).css('pointer-events','none');
					
					/* if( settings.indexOf( id ) > -1 ) 
						$( el ).find(elSel).prop('required', true ); */
					if( settings.indexOf( id ) === -1 ) $( el ).find(elSel).prop('required', req );
									
					if ( visb || (mobile && window.innerWidth < 768) ){
						
						el = $(el).hide();
						$('#sepetim_total').find('#'+id).hide();
						
					}
					
					if ( pstId ){
						
							var control = $.grep( objectPst, function (v){ if  (v){ return v[pstId];  }else { return; } });
							
							if ( control.length > 0 ){
								//console.log(control[0]);
									var ıtem = '';
									$.each(control[0], function(ke,va){
										 ıtem = $.grep(va, function (v){
												return v.item.data == id;
											
											}); // each va
	
									});// each control[0]
									
									if ( ıtem.length > 0) {
										//console.log(ıtem);
										
											var ItemId		= ıtem[0].item.data,
												Itemvisb	= ıtem[0].item.visb,
												Itemreq		= ıtem[0].item.req,
												Itemread	= ıtem[0].item.read;
	
											$( el ).find(elSel).prop('readonly', Itemread );
											
											if(Itemread)
												$( el ).find(elSel).attr('disabledElement',1).css('pointer-events','none');
											
											if( settings.indexOf( id ) === -1 ) $( el ).find(elSel).prop('required', Itemreq );
											
											//$( el ).find(elSel).prop('required', Itemreq );
											
											if ( Itemvisb ) el = $(el).hide();
											
											
											if (!Itemvisb){
												
													if( $(el).is(':visible') ) el = $(el).show();
												
												}else {
													
													if( !$(el).is(':visible') ) el = $(el).hide();
					
													}// if Itemvisb
										
											}// if ıtem.length
								
								}// if control.length
						
						} // if pstId
			
					columnPanel.append(el);
			
				}); // each

			$("div[type='column']").each(function(index,element){
				if($(element).find('div').length == 0)
					$(element).remove();
			});
			
			if($('#basketIframe').length || $('.pod_basket').length){

				if(formObjects.column.pageType == "tabs"){
					if($(window).width() < 767){
						$('.row .uniqueRow > .row').slick({
							items:1,
							dots:false,
							loop:false,
							speed: 750,
							infinite: false,
							arrows: false,
							swipeToSlide: true,
							//adaptiveHeight: true
						});
	
						$(document).scrollTop(0);
	
						if($('#basketIframe').length){
							$('#sepetim').parent().append('<div class="basketBtn"><div id="basketPrev"><i class="icon-chevron-left"></i></div><div id="basketNext"><i class="icon-chevron-right"></i></div></div>');
	
						$('#basketNext').click(function(){
							$('.fht-tbody').animate({
								scrollLeft: "+=250px"
							}, 500)
						});
	
						$('#basketPrev').click(function(){
							if($('.fht-tbody').scrollLeft() != 0){
								$('.fht-tbody').animate({
									scrollLeft: "-=250px"
								}, 500)
							}
						});
						}
						else if($('.pod_basket'))
						{
							$('.pod_basket').parent().append('<div class="basketBtn"><div id="basketPrev"><i class="icon-chevron-left"></i></div><div id="basketNext"><i class="icon-chevron-right"></i></div></div>');
	
						$('#basketNext').click(function(){
							$('#table1').animate({
								scrollLeft: "+=250px"
							}, 500)
						});
	
						$('#basketPrev').click(function(){
							if($('#tabl1').scrollLeft() != 0){
								$('#table1').animate({
									scrollLeft: "-=250px"
								}, 500)
							}
						});
						}
	
						
	
						$('.row .uniqueRow > .row').on('swipe', function(event, slick, direction){
	
							$("html, body").animate({
								scrollTop : 0
							}, 500);
	
							var currentSlide = $('.row .uniqueRow > .row').slick('slickCurrentSlide');
							$('.nav-basket li').removeClass();
							$('.nav-basket li').eq(currentSlide).addClass("active");
	
							var offL = $('.nav-basket li.active').position().left;
							$('.nav-basket').animate({scrollLeft: offL}, 750);
	
							var currentWidth = $(window).height() - $('.header').height() - $('.page-bar').height() - $('#pageHeader').height() - $('.nav-basket').height();
							
							if($('.slick-current').height() < currentWidth){
								$('body').css("overflow", "hidden");
								$('.slick-list').css("height", "auto");
								
							}else{
								$('body').css("overflow", "auto");
								$('.slick-list').css("height", $('.slick-current').height() +20);
							}
	
						  });
	
					}
				}

				else if(formObjects.column.pageType == "step"){
					if($(window).width() < 767){
						$('.row .uniqueRow > .row').slick({
							items:1,
							dots:false,
							loop:false,
							speed: 750,
							infinite: false,
							arrows: false,
							swipeToSlide: true,
							//adaptiveHeight: true
						});
	
						$(document).scrollTop(0);
	
						$('#sepetim').parent().append('<div class="basketBtn"><div id="basketPrev"><i class="icon-chevron-left"></i></div><div id="basketNext"><i class="icon-chevron-right"></i></div></div>');
	
						$('#basketNext').click(function(){
							$('.fht-tbody').animate({
								scrollLeft: "+=200px"
							}, 500)
						});
	
						$('#basketPrev').click(function(){
							if($('.fht-tbody').scrollLeft() != 0){
								$('.fht-tbody').animate({
									scrollLeft: "-=200px"
								}, 500)
							}
						});
	
						
	
						$('.row .uniqueRow > .row').on('swipe', function(event, slick, direction){
	
							$("html, body").animate({
								scrollTop : 0
							}, 500);
	
							var currentSlide = $('.row .uniqueRow > .row').slick('slickCurrentSlide');
							$('.nav-step li').removeClass();
							$('.nav-step li').eq(currentSlide).addClass("active");
	
							var offL = $('.nav-step li.active').position().left;
							$('.nav-step').animate({scrollLeft: offL}, 750);
	
							var currentWidth = $(window).height() - $('.header').height() - $('.page-bar').height() - $('#pageHeader').height() - $('.nav-step').height();
							
							if($('.slick-current').height() < currentWidth){
								$('body').css("overflow", "hidden");
								$('.slick-list').css("height", "auto");
								
							}else{
								$('body').css("overflow", "auto");
								$('.slick-list').css("height", $('.slick-current').height() +20);
							}
	
						  });
	
					}
				}
			}

	}; // shiftElement
	
var updateObject = function (e, positionId ){
		//console.log (e,positionId);
	
	"use Strict";

		var el 			= $(e),
			pId 		= positionId,
			row 		= el.closest('div.row').children(),
			boxClass 	= '.SettingsBox',
			boxId 		= el.parents('div'+boxClass).attr('id'),
			formItem 	= 'item-'+boxId.split('-')[1],
			object 		= formObjects.positions,
			position 	= $.grep(object, function (v){return v[pId];}),
			
			visb = row.find('input[type="checkbox"][id="visible"]').is(':checked'),
			req  = row.find('input[type="checkbox"][id="require"]').is(':checked'),
			read = row.find('input[type="checkbox"][id="readonly"]').is(':checked');
							
		if ( position.length !== 0) {
			
				$.each(position, function (k,v){
					//console.log (k,v)
					
								$.each(v, function(ke,va){
									//console.log (ke,va)
										
										var control = $.grep(va,function (v){ return v.item.data === formItem; });
										
											if ( control.length > 0 ) {

													$.each(control, function (key, val ){
															//console.log (key,val)

																$.extend( val.item, { visb : visb , req : req , read : read });			
																return false;
	
														}); // each control
												
												} else {
	
														v[pId].push({ "item" : { data : formItem,  visb : visb , req : req , read : read } });
										
													} // if control.length

										}); // each v			
				
						}); // each position
			
			} else {
				
					var item	= {};
						item[pId]	= [] ;
						item[pId].push({ "item" : { data : formItem,  visb : visb , req : req , read : read } });
				
					object.push(item); 
					
				}// ifposition.length 
		
		
		//console.log(object)
		//console.log (  formObjects )
		//console.log ( JSON.stringify( formObjects) )
	}; // updateObject	

var sortObject = function (controllerName, eventList){ // systemmodaldaki form değerlerini doldurur
	"use strict";	
	
			var sorterClass	= 'sorter',
				rowSort		= $('div[type="rowSort"]'),
				object 		= formObjects,
				copyObject  = [];

				if( object.all.length !== 0 ) {
					
						object.all.length = 0;
						object.column.pageDesign.length = 0;
						
					}
			
			$.each(rowSort,function(k){
					
					var columnSort	= $(this).find('div[type="columnSort"]'),
						rowCount	= k,
						slideBox	= false,
						slideBoxName; 
						
						
					if ( eval ( $(this).attr('slideBoxSort') ) ){

						slideBox		= true;
						slideBoxName	= $(this).find('div[type="slideBoxName"] input[type="text"]').val() || null;
				
					} // if
					

					$.each(columnSort, function () {
							
							var sorter		= $(this).find('.' + sorterClass),
								items		= sorter.children('li'),
								colmn		= $(this).attr('index'),
								columnClass	= $(this).attr('class').split(' ');
								
								if(items.length || colmn == 20 || colmn == 21 || colmn == 22) // kolon eklenmistir. Ama ici bostur.
								{
									object.column.pageType = $("select#pageType").val();

									object.column.pageType_screen = $("select#pageType_screen").val();
									
									copyObject.push({ index : colmn, rowCount : rowCount, class : [ columnClass[0], columnClass[1]].join(' '), slideBox : slideBox, slideBoxName :slideBoxName });
									
									
									$.each(items, function (k,v) {
											//console.log(v)
											//console.log($(this).attr('item'));
											var li		= $(v),
												item	= li.attr('item'),
												visb	= li.find('input[id="visible"]').eq(0).is(':checked'),
												req		= li.find('input[id="require"]').eq(0).is(':checked'),
												read	= li.find('input[id="readonly"]').eq(0).is(':checked'),
												mobile  = li.find('input[id="mobile"]').eq(0).is(':checked')
												;
											
											//console.log(visb);
											
											object.all.push({ item : { colmn : colmn, data : item, visb : visb, req: req, read : read, mobile: mobile} }); // push
											
										});// each
								
									//_el.sortable('destroy');
							
								}
							
						});// each
				
				});
				
				object.column.pageDesign = copyObject;
				
			//console.log (JSON.stringify( object ) );
			/* console.log(formObjects); */
			//console.log ( JSON.stringify( formObjects) );
			//return false;
			$('#working_div_main').show();
				$('#working_div_main').promise().done(function(){
					var allCompanySave = 0
					if($("#all_company").is(':checked'))allCompanySave = 1
					callAjax('index.cfm?fuseaction=objects.emptypopup_formBuilder&fromModified=1&isAjax=1&xmlhttp=1&_cf_nodebug=true&allCompanySave='+allCompanySave+'&controllerName='+controllerName+'&eventList='+eventList,handlerPost,{ modifieData: encodeURIComponent(JSON.stringify( formObjects))});
			})
			
	}; // sortObject	
	
var columnSettings = function ( hdlr, controllerName, el ){
//	console.log(el);
	"use strict";

		var columnName		= 'column',
			modalId			= 'formPanel',
			handleEl		= '.form-group',
			sorterClass		= 'sorter',
			editId			= 'frmEdit',
			modalPanel 		= $('*').find('div#' + modalId ),
			modalBody		= modalPanel.find('.modal-body'),
			modalFooter		= modalPanel.find('.modal-footer'),
			modalBodyId		= modalBody.find('#' + editId),
			object 			= formObjects.all,
			elControl		= settings,
			objectEvent		= el;
	
		var sortableSettings = {
						
					column	: {
						
							connectWith		: '.' + sorterClass,
							handle			: '.handle',
							cursor			: 'move',
							opacity			: '0.6',
							placeholder		: 'form-group-corner-all',
							revert			: 300
							
						},
						
					row 	: {
						  
						connectWith		: 'div[type="rowSort"]',
						handle			: '.sorterHead',
						items			: 'div[type="columnSort"]',
						cursor			: 'move',
						opacity			: '0.6',
						placeholder		: 'row-group-corner-all',
						revert			: 300
						  
						  }	
						  
				}; //sortableSettings
				
		var columnOptions = { 
					1:	'col col-1', 
					2:	'col col-2', 
					3:	'col col-3', 
					4:	'col col-4', 
					5:	'col col-5', 
					6:	'col col-6', 
					7:	'col col-7', 
					8:	'col col-8', 
					9:	'col col-9', 
					10:	'col col-10', 
					11:	'col col-11', 
					12:'col col-12'
				 }; // columnOptions

		var functions = {
			
				addColumn : function (){
	
							var columnCount =  modalBodyId.find('div[type="columnSort"]');
										
							$('<div>')
								.addClass( 'col col-3' )
								.attr({
									'type'  : 'columnSort',
									'index' : parseInt(columnCount.length + 1 ),
									})
								.append(
									$('<div>')
										.addClass('sorterHead')
										.append(
												$('<span>').addClass('pull-left sorterElementName').append(language.kolon + ' ' + parseInt(columnCount.length + 1 ) ),
												$('<div>').addClass('pull-right sorterPermissionIcon')
													.append(
														$('<div>').addClass('colNumber')
														.append(
														
															$('<select>')
																.attr('onChange', 'columnSettings("columnChange",null,this)')
																.append(function() {
																		
																		var selectBox = this;
																		
																		$.each(columnOptions,function(k,v){
																					
																				var selected;	
																				( String(v)  === String( 'col col-2' ) ) ? selected = true : selected = false;
																			
																				$('<option>').val(v).text(k).prop('selected',selected).appendTo(selectBox);	
																			
																			});
																})
														
														),
													$('<i>').addClass('icon-eye-slash').attr('title', language.aktif),
													$('<i>').addClass('icon-asterisk').attr('title', language.zorunlu),
													$('<i>').addClass('icon-lock').attr('title', language.sadeceOkunur),	
													$('<i>').addClass('icon-phone').attr('title', 'mobilde gizle').attr('style', 'font-size: 16px'),																	
													$('<i>').addClass('icon-cogs')																		
												)
										),											
									$('<ul>')
										.addClass( sorterClass )
										.sortable( sortableSettings.column )
								).appendTo(modalBodyId.find('div[type="rowSort"]:last'));
					
				}, // add
					
				delColumn : function (){
					
						var uls		= modalBodyId.find('ul.'+ sorterClass),
							control	= $.grep(uls, function(v,k){ return $(v).children().length === 0;}), // grep
							ul		= control[control.length-1];
					
						if ( ul ) {
							
								var column	= $(ul).parent('div[type="columnSort"]'),
									row		= column.parent('div[type="rowSort"]');
									
								column.remove();
								if (row.children().length === 0 ) row.remove();
							} // if
							
					}, // del
				
				returnDefault : function (controllerName,objectEvent){
						//console.log (objectEvent);
						var allCompanySave = 0
						if($("#all_company").is(':checked'))allCompanySave = 1
						callAjax('index.cfm?fuseaction=objects.emptypopup_formBuilder&fromModified=0&isAjax=1&xmlhttp=1&_cf_nodebug=true&allCompanySave='+allCompanySave+'&controllerName='+controllerName+'&eventList='+objectEvent,handlerPost);
						
					
					}, 
				
				addRow : function (){
						var notAppend = 0;
						var rows	= $("div[type='rowSort']");
						$.each(rows, function(k){
							if(!$(rows[k]).find('div[type="columnSort"]').length){
								notAppend = 1;
							}
						});
						if(!notAppend)
						{
							var itemCounter = rows.length;
							var itemId = 'item'+rows.length;
							$('<div id='+itemId+' indis='+itemCounter+'>')
								.addClass('row')
								.attr('type','rowSort')
								.append(
									$('<div>')
										.addClass('col col-12 col-md-12 col-sm-12 col-xs-12 ui-form-list flex-list')
										.attr('type','slideBoxName')
										.append($('<input>').attr({'type' : 'checkbox' , 'onChange' : 'columnSettings("makeSlideBox",null,this)'}))
									
									)
								.appendTo(modalBodyId)
								.sortable(sortableSettings.row);
						}
					},
					
				delRow : function(){
					
					var rows	= $("div[type='rowSort']");
					$.each(rows, function(k){
						if(!$(rows[k]).find('div[type="columnSort"]').length)
							$(rows[k]).remove();
						});
					
					},
					
				columnChange : function(){
					
						var element	= $(el),
							row		= element.parents('div[type="rowSort"]'),
							column	= element.parents('div[type="columnSort"]'),
							val		= element.val();
						
						column.removeAttr('class').toggleClass(val);
					
					},
					
				makeSlideBox : function (){		
					
						var element	= $(el),
							row		= element.parents('div[type="rowSort"]'),
							status	= element.prop('checked');
						
						if(status){
							var frmgrpL = element.parent().find('.form-group').length;
							if(frmgrpL == 0){
								element.after($('<div>').attr( 'class','form-group col col-2 col-xs-12'));
							
							$('<div class="input-group"></div>').appendTo( $(".form-group") );
							
							var iGroup = element.parent().find('.input-group');
							$('<input name="head" id="head" type="text" placeholder="Row Name">').appendTo( iGroup );
							$('<input type="hidden" name="dictionary_id" id="dictionary_id">').appendTo( iGroup );
							$('<input type="hidden" name="woid"  id="woid">').appendTo( iGroup );
							$('<span class="input-group-addon icon-ellipsis btnPointer"></span>').appendTo( iGroup );
							
							
							var indis = parseInt(row.attr("indis")) + 1;
							iGroup.find('.input-group-addon').attr("onClick", 'windowopen(\'index.cfm?fuseaction=settings.popup_list_lang_settings&is_use_send&lang_dictionary_id=formBuilder[0].dictionary_id['+indis+']&lang_item_name=formBuilder[0].head['+indis+']\',\'list\');return false;');
							
							
							
							}
							
						}
						else{

							element.parent().find('.form-group').remove();
							
						}
						row.attr('slideBoxSort',status);
						
					
					}	
			
			}; // functions
	
		functions[hdlr].apply(this, [controllerName,el]);
	
	}; //columnSettings

var slideBoxToggle = function(el, openFunction){
	
	"use strict";

	var box = $(el).parent('div.catalyst-seperator').next('div');
	
	box.slideToggle(200,function(){
		if ($(el).find("i").hasClass("icon-angle-right")) {
			$(el).find("i").removeClass("icon-angle-right").addClass("icon-angle-down");
			if(openFunction != "" && typeof eval(openFunction) == 'function') openFunction();
		}
		else $(el).find("i").removeClass("icon-angle-down").addClass("icon-angle-right");
	});

}; // slideBoxToggle
	

var sortDetPage = function (controllerName, returnDefault ) {
		//console.log(settings);
		
		var columnName		= 'column',
			modalId			= 'formPanel',
			editId			= 'pageEdit',
			handle	        = 'uniqueRow',
			sorter			= 'sorter',
			modal 			= $('*').find('div#' + modalId ),
			modalHeader		= modal.find('.modal-header'),
			modalBody		= modal.find('.modal-body'),
			modalFooter		= modal.find('.modal-footer'),
			editTab			= modal.find('#' + editId),
			object 			= formObjects.all,
			elControl		= settings,
			colmClass,div;
	
		var sortableSettings = {
						
					column	: {
						
							connectWith		: '.' + sorter,
							handle			: '.handle',
							cursor			: 'move',
							opacity			: '0.6',
							placeholder		: 'form-group-corner-all',
							revert			: 300
							
						},
						
					row 	: {
						  
						connectWith		: 'div[type="pageRowSort"]',
						handle			: '.sorterHead',
						items			: 'div[type="pageColumnSort"]',
						cursor			: 'move',
						opacity			: '0.6',
						placeholder		: 'row-group-corner-all',
						revert			: 300
						
						  }	
						  
				}; // sortableSettings
				
		var columnOptions = { 
					1:	'col col-1', 
					2:	'col col-2', 
					3:	'col col-3', 
					4:	'col col-4', 
					5:	'col col-5', 
					6:	'col col-6', 
					7:	'col col-7', 
					8:	'col col-8', 
					9:	'col col-9', 
					10:	'col col-10', 
					11:	'col col-11', 
					12:'col col-12'
				 }; // columnOptions
			
		var rows	= $('div[class*="uniqueRow"]').parent();
		
		
		$.each(rows, function(k){
			
				var mainRow 	= $(this),
					column		= mainRow.find('div.uniqueRow'),
					rowCount	= k,
					slideBox	= $(this).attr('slideBox'),
					attr		= {},
					input;
					
					$.extend(attr,{type: 'rowSort'});
					
					
					if(column.length)
					{
						$.each(column,function(t){
						
							
								var cols 	= $(this),
								elements	= cols.find('div.uniqueBox'),
								index		= t,
								columnClass	= $(this).attr('class').split(' ');

								
							 $('<div>')
								.addClass( [ columnClass[0], columnClass[1]].join(' ') )
								.attr({
									'type' :'columnSort',
									'index' : index
									})
								.append(function(){
									var div = this;
									$('<div>')
										.addClass('sorterHead')
										.append(
												$('<span>').addClass('pull-left sorterElementName').append(language.kolon + ' ' + index ),
												$('<div>').addClass('pull-right sorterPermissionIcon')
													.append(
														$('<div>').addClass('colNumber')
															.append(
															
																$('<select>')
																	.attr({'onChange': 'columnSettings("columnChange",null,this)','item':'detSort'})
																	.append(function() {
																			
																			var selectBox = this;
																			
																			$.each(columnOptions,function(k,v){
																						
																					var selected;	
																					( String(v)  === String( [ columnClass[0], columnClass[1]].join(' ') ) ) ? selected = true : selected = false;
																				
																					$('<option>').val(v).text(k).prop('selected',selected).appendTo(selectBox);	
																				
																				});
																	})
															
															)																	
													)
											).appendTo(div);
											
										$('<ul>')
											.addClass( sorter )
											.append(function(){
											
												var ul = this ;
												
												$.each(elements, function (key,val) {
													
														//console.log($(val).attr('id'));
													
														var _el				= $(val),
																divId			= _el.attr('id'),
																divLabel		= _el.find("span a").text() || _el.attr('itemTitle') || 'main',			 		 			
																SettingClick	= "modalDesigner('" + divId + "')",
																refreshClick	= "modalDesigner('" + divId+ " ','ref')",
																visb, read, req, visible, require, readonly, positionIcon;
																
																

																if($(val).css('display') == 'none')
																	prop = false;
																else
																	prop = true;
																
																if(!divId)
																	 divId = 'unique_main';
																
														$('<li>')
															.attr( 'item',divId )
															.append( 
																	$('<div>')
																		.addClass('row')
																		.append(
																			$('<span>').addClass('pull-left sorterElementName handle').append( divLabel ),
																			$('<input>').attr({'type' : 'checkbox' ,'class':'pull-right','name':divId,'id':divId}).prop('checked',prop)
																		),
																	$('<div>').addClass('row SettingsBox scroll-sm').attr('id' , divId + '-SettingsBox' )
																)
															.appendTo( ul );
		
													}); // each 
											})
											.appendTo(div)
											.sortable(sortableSettings.column);
											
									}).appendTo($("#pageEditDiv"));
							})
						
					}

			}); // each

		var clickFunction 		= 'sortPageObject(\''+controllerName+'\',0)';
		var clickReturnFunction = 'sortPageObject(\''+controllerName+'\',1)';
		
		if(returnDefault)
		{
			editTab.find("input.hide").attr('onClick',clickReturnFunction);
			editTab.find("input.hide").removeClass('hide');
		}

		editTab.find('input#actionButton').attr('onClick',clickFunction);
									
				
	}; // sortPage	
	
	
var sortPageObject = function (controllerName,isDel){
		
	"use strict";	
			if(!isDel)
			{
				var sorterClass	= 'sorter',
					rowSort		= $('#pageEditDiv div[type="columnSort"]'),
					objectDet 	= formObjects,
					copyObject  = [];

				$.each(rowSort,function(k){
						
						var columnSort	= $(this).find('li[item^="unique"]'),
							rowCount	= k,
							selectClass	= $(this).find('select[item="detSort"]').val();
							
							copyObject.push({ index : k, class : selectClass});
							
						$.each(columnSort, function (l) {
								
								var items		= $(this).find("input"),
									//visb 		= $(this).find("input").prop('checked')
									rowCount	= l;
			
								$.each(items, function (k2,v) {
										//console.log(v)
											
										var li		= $(v),
											item	= li.attr('id'),
											visb	= li.prop('checked');
										
										objectDet.all.push({ item : { column : k, colmnIndex : l, data : item, visb : visb} }); // push
										
									});// each
					
								
							});// each
					
					});

					objectDet.column.pageDesign = copyObject;
					
			}
			var allCompanySave = 0
			if($("#all_company").is(':checked'))allCompanySave = 1
			callAjax('index.cfm?fuseaction=objects.emptypopup_formBuilder&fromModified=1&isAjax=1&xmlhttp=1&_cf_nodebug=true&allCompanySave='+allCompanySave+'&controllerName='+controllerName+'&isDelFromDet='+isDel+'&eventList=detSort',handlerPost,{ modifieData: encodeURIComponent(JSON.stringify( objectDet))});


	}; // sortObject	
	
	var sortDetElement = function ( row, items, controllerName ){
		"use strict";
		
		var colData = $.parseJSON(row);
		var itemsData = $.parseJSON(items);
		
		//console.log(itemsData);
		//console.log(colData);
		/*
		upd:	09102019 UH
		desc: 	Daha önce json oluşturulmadığı için direkt olarak uniqueRow u silerek tasarımın page designer a taşınmasına engel oluyordu.
				Bu nedenle json length kontrol edildi ve eğer kayıt varsa body tasarımının oluşturulması sağlandı.
		*/
		if (colData.pageDesign.length)
		{
			$("<div>").attr({'class':'row','id':'pageLayoutInside'}).appendTo($('.pageMainLayout'));
			$("div.pageMainLayout").find("div.uniqueRow").removeClass('uniqueRow');
			
			$.each(colData.pageDesign, function (k,v){
				//console.log(k,v)
				$("<div>").attr({'class':v.class + ' col-xs-12 uniqueRow','detIndex':k}).appendTo($("#pageLayoutInside"));
				
				$.each(itemsData, function (k2,v2){
					if(v2.item.column == k)
					{
						if(v2.item.visb == true)
							$("#"+v2.item.data).appendTo("div[detIndex="+k+"]");
						else
							$("#"+v2.item.data).appendTo("div[detIndex="+k+"]").css('display','none');
					}
					else
					{
						//console.log(v2);	
					}
				});
				
			}); // each data	
		}
			
		sortDetPage(controllerName,1);
	
	}; // shiftElement

var DuxiParser = function(setup) {
	const defaults = {
		boxSelector: ".uniqueBox",
		rowSelector: "div[type=\"row\"]",
		colSelector: "div[type=\"column\"]",
		hiddenSelector: "input[type=\"hidden\"]",
		elementSelector: ".form-group"
	}
	this.settings = Object.assign({}, defaults, setup);

};
DuxiParser.prototype.parse = function() {
	let boxes = $(this.boxSelector).get();
	this.rows = boxes.map((e, i) => {
		let box = {};
		box.box = [].slice.call($(e).get()[0].attributes).reduce((a, e) => { a[e.name] = e.value; return a; }, {});
		box.rows = [].slice.call($(e).find(this.rowSelector).get().map(e => { e }));
	});
}