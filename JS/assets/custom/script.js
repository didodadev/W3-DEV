/**
	//////////////////////////////////// script.js Functions /////////////////////////////

	openLeftSubMenu		:
	periodChange		:
	resizeControl		:
	loadControl			:
	keyControls			:
	openBox				:
	rightClickNone		:
	modalDesigner		:
	openEmployee		:
	printElement		:
	PrintPagesize		:
	savePrint			:
	DeletePrintEl		:
	stringToLowerCase	:
	myPopup				:
	createModal			:
	alertObject			:
	dropdown-toggle		:
	FullScreen			:

	//Oluşturan : Emrah Kumru
**/

var openLeftSubMenu = function ( id ) {

	var elemetnId 		= id ;
	var element 		= $('li[id="'+ elemetnId + '"]');
	var subMenu 		= element.parent('ul');
	var subMenuParent 	= subMenu.parent('li');
	var subMenuChild 	= element.children('a');
	var responsePanel 	= $('.leftBar #responseSearch');
	var sideBarMenu 	= $('#sidebar-menu');
	var responseInput	= $('input#leftMenuSearch');

	openPanel().leftPanel('push'); // sidebar left open function

	if ( responsePanel.is(':visible') ) responsePanel.slideToggle('fast'),sideBarMenu.show(),responseInput.val('');
	if ( !subMenu.hasClass('openSubMenu') )	subMenuParent.children('a').trigger('click');

		subMenuChild.trigger('click').delay(600);

};//openLeftSubMenu

var periodChange = function (params,xmlFuseaction) {
var rightBar= $('.rightBar');
var periodMenu = $('.rightBar div#systemperiod');
	if(rightBar.hasClass('rightBarOpen push') && periodMenu.css('display')!='block')
		periodMenu.slideToggle(200);
	else{
		rightBar.toggleClass('rightBarOpen push');
		periodMenu.css('display','block');
		$.ajax({ url: 'index.cfm?fuseaction=objects.rightBarObjects&ajax=1&ajax_box_page=1&isAjax=1&XmlFuseaction='+xmlFuseaction+'&fuseact='+params+'&'+$("#add_to_favorites").serialize(), async:false, success: function(data) {
				$("#tab-content").html(data);
				rightMenuContent('period','systemperiod');

		   }
		}); // ajax
	}
};// periodChange


var keyControls = function (){

	var __window 	= window;

	return {

		leftPanel : function (settings){

				var panelClass 			= settings.panel;
				var panelActiveClass	= settings.panelActive;
				var panelSearchId 		= settings.panelSearch;
				var panelMenuId			= settings.panelMenu;
				var panel				= $('div[class="'+ panelClass +'"]');
				var menuEl				= panel.find('div[id="'+panelMenuId +'"]');
				var panelMenu			= panel.find('ul.menu-content');
				var panelSearch			= panel.find('div[id="'+ panelSearchId +'"]');
				var __activeClass 		= 'keyActive';

				var menuList = {

							first		: panelMenu.children('li:first').find('a:first'),
							up			: null,
							last		: panelMenu.children('li:last').find('a:first'),
							down		: null,
							current		: null

					};//MenuList

				var	searchList = {first: null,up: null,last: null,down: null,current:null};//searchList


					$(__window).bind('keyup',function( e ){
							//var __nodeName = e.target.nodeName
							var keyCode 	= e.keyCode || e.which ;
							var ctrl 		= e.ctrlKey;

							var control = $.map( keyCodes, function (k,v){return k;});//map

							if ( control.indexOf(keyCode) < 0 ) return; // control
							if ( ctrl && keyCodes.left == keyCode ) /*open leftPanel */ openPanel().leftPanel('push'); // sidebar left open function


							if ( !panel.hasClass( panelActiveClass ) ) return;
							if ( keyCodes.esc == keyCode ) $('.page-logo').trigger('click'); $('.leftBar input#leftMenuSearch ').blur();


							if ( searchList.first != null && !$('*').find(searchList.first).get(0)  ) {
									searchList = {first: null,up: null,last: null,down: null};//searchList
								}// if


							//menu key control
							if ( menuEl.is(':visible') ){

									 // down
									 if ( keyCodes.down == keyCode ){

											if ( menuList.current == null ){

													menuList.current	= menuList.first;
													menuList.up			= menuList.last;
													menuList.down		= menuList.current.parent('li').next().find('a:first');

												} // if menuList current

											var currentEl	= menuList.current;
											var upEl		= menuList.up;
											var downEl		= menuList.down;

											if ( !currentEl.hasClass( __activeClass ) ) {

													currentEl.addClass( __activeClass );
													menuList.last.removeClass( __activeClass );

												}else {

													currentEl.removeClass( __activeClass );
													downEl.addClass( __activeClass );

														menuList.current	= downEl;
														menuList.up			= downEl.parent('li').prev().find('a:first');
														menuList.down		= downEl.parent('li').next().find('a:first');

														if ( menuList.down.length === 0 ) menuList.current = null;

													}//if firstEl hasClass

									 } // if

									 // up
									 if ( keyCodes.up == keyCode ){

										if ( menuList.current == null ){

													menuList.current	= menuList.last;
													menuList.up			= menuList.current.parent('li').prev().find('a:first');;
													menuList.down		= menuList.first;

												} // if menuList current

											var currentEl	= menuList.current;
											var upEl		= menuList.up;
											var downEl		= menuList.down;


											if ( !currentEl.hasClass( __activeClass ) ) {

													currentEl.addClass( __activeClass );
													menuList.first.removeClass( __activeClass );
												}else {

													currentEl.removeClass( __activeClass );
													upEl.addClass( __activeClass );

														menuList.current	= upEl;
														menuList.up			= upEl.parent('li').prev().find('a:first');
														menuList.down		= upEl.parent('li').next().find('a:first');

														if ( menuList.up.length === 0 ) menuList.current = null;

													}//if firstEl hasClass

											 } // if

									 //	enter
									 if (  keyCodes.enter == keyCode ){

												var currentEl = menuEl.find('a[class="'+ __activeClass +'"]')
													currentEl.trigger('click');

											}//if

								}// if menuEl visible

							//search key control
							if ( panelSearch.is(':visible') ){

									var SearchContent = panelSearch.find('ul.sub-menu');

									if ( searchList.first == null && searchList.last == null ) {

											searchList.first 	= SearchContent.children('li:first').find('a:first'),
											searchList.up	 	= null
											searchList.last	 	= SearchContent.children('li:last').find('a:first'),
											searchList.down	 	= null,
											searchList.current	= null

										};//searchList

									 // down
									 if ( keyCodes.down == keyCode ){

											if ( searchList.current == null ){

													if ( searchList.down != null && searchList.down.length === 0 ) searchList.last.removeClass(__activeClass);

														searchList.current	= searchList.first;
														searchList.up		= searchList.last;
														searchList.down		= searchList.current.parent('li').next().find('a:first');

													} // if menuList current

												var currentEl	= searchList.current;
												var upEl		= searchList.up;
												var downEl		= searchList.down;

												if ( !currentEl.hasClass( __activeClass ) ) {

														currentEl.addClass( __activeClass );

													}else {

														currentEl.removeClass( __activeClass );
														downEl.addClass( __activeClass );

															searchList.current	= downEl;
															searchList.up		= downEl.parent('li').prev().find('a:first');
															searchList.down		= downEl.parent('li').next().find('a:first');

															if ( searchList.down.length === 0 ) searchList.current = null;

														}//if firstEl hasClass

											} // if

									 // up
									 if ( keyCodes.up == keyCode ){

												if ( searchList.current == null ){

														if ( searchList.up != null && searchList.up.length === 0 ) searchList.first.removeClass(__activeClass);

														searchList.current	= searchList.last;
														searchList.up		= searchList.current.parent('li').prev().find('a:first');;
														searchList.down		= searchList.first;

													} // if menuList current

												var currentEl	= searchList.current;
												var upEl		= searchList.up;
												var downEl		= searchList.down;


												if ( !currentEl.hasClass( __activeClass ) ) {

														currentEl.addClass( __activeClass );

													}else {

														currentEl.removeClass( __activeClass );
														upEl.addClass( __activeClass );

															searchList.current	= upEl;
															searchList.up		= upEl.parent('li').prev().find('a:first');
															searchList.down		= upEl.parent('li').next().find('a:first');

															if ( searchList.up.length === 0 ) searchList.current = null;

														}//if firstEl hasClass

											 } // if

									 //	enter
									 if (  keyCodes.enter == keyCode ){

												var currentEl = SearchContent.find('a[class="'+ __activeClass +'"]');
													currentEl[0].click();

											} // if


								}// if panelSearch visible

						});//__window bind 'keydown'


			},// leftPanel

		rightPanel : function (){


			if ( ctrl && __arrowKeyCodes.indexOf( keyCode ) == 2 ) /*open leftPanel */ openPanel().rightPanel('push'); // sidebar left open function



			}//rightPanel

		}//return


};// keyContols

var resizeControl = function (){
var h = $(window).height();
var w = $(window).width();

// rightPanel
var rightbarTabHeight = $(window).height()-102;
var rigtbarChatHeight = $(window).height()-182;
$('.rightmenu-content.scrollContent').css({'height':rightbarTabHeight});
$('.rightbar-chat-user-messages.scrollContent').css({'height':rigtbarChatHeight});

//pageBar
var Plg = 750, // 3
	Pmd = 500, // 2
	Psm = 400; // 1

$.each(responsiveMenus.pageBar,function(k,v){ pageBarEl = $(v.el);}); // each


if(responsiveMenus.pageBar.length) // PageBar'ın gelmediği menülerde sıkıntı oluyordu.
{
	if (w <= Plg && w > Pmd  ) {
			pageBarEl.empty();	pageBar('set',pageBarEl,3);
		}else if ( w <= Pmd && w > Psm ){
				pageBarEl.empty();	pageBar('set',pageBarEl,2);
			}else if ( w <= Psm ){
					pageBarEl.empty(); pageBar('set',pageBarEl,1);
				}else if (w > 750 ){
						pageBarEl.empty(); pageBar('set',pageBarEl);
					}; //if
}
//tabMenus
if ( responsiveMenus.tabMenus.length != 0){

		var Tlg = 850, // 3
			Tmd = 700, // 2
			Tsm = 600; // 1

		$.each( responsiveMenus.tabMenus, function(k,v){ tabMenusEl = $(v.el);}); // each

		if($("#efatura_display").length)
			uniqueId = 	'efatura_display';
		else
			uniqueId = 	'earchive_display';
		var transformationData = $("#"+uniqueId);
		var transformationData2 = $("#"+uniqueId+'Ul');

		if ( w <= Tlg && w > Tmd  ) {tabMenusEl.empty();	tabMenus('set',null,tabMenusEl,3);
			}else if ( w <= Tmd && w > Tsm ){tabMenusEl.empty(); tabMenus('set',null,tabMenusEl,2);
				}else if ( w <= Tsm ){tabMenusEl.empty(); tabMenus('set',null,tabMenusEl,1);
					}else if (w > 750 ){tabMenusEl.empty();	tabMenus('set',null,tabMenusEl);

						}; //if

		$("<li>").attr({'class':'dropdown','id':'transformation'}).appendTo($("#tabMenu ul:first-child"));
		$(transformationData).css('display','');
		$(transformationData2).css('display','');
		$(transformationData).appendTo($("#transformation"));
		$(transformationData2).appendTo($("#transformation"));

	};// responsiveMenus.tabMenus control

};// resizeControl
$(window).resize(function() {
	resizeControl();
}); // window resize

var loadControl = function (){

	$(window).load(function() {
			var h = $(this).height();
			var w = $(this).width();

			//rightPanel
			var rightbarTabHeight = $(window).height()-102;
			var rigtbarChatHeight = $(window).height()-182;

			$('.rightmenu-content.scrollContent').css({height:rightbarTabHeight});
			$('.rightbar-chat-user-messages.scrollContent').css({height:rigtbarChatHeight});

		}); //load control


}// loadControl

var openBox = function ( url, e, id ){

	if(arguments[2]!=null)
		var id = id;
	else
		var id = 'deneme';

	var	cls = 'importPanel';
	var	el = $(e);
	var	elTop	= el.parents('ul').offset().top;
	var	elLeft = el.parents('ul').offset().left;
	var topPosition = 39;
	var leftPosition =	400;
		var control = el.closest('div').find('.' + cls );

			if ( control.is(':visible') ) control.remove();

	style = {
			'top' : elTop + topPosition,
			'left' :elLeft - leftPosition
		}// style

	div = $('<div>')
			.attr('id',id)
			.addClass(cls)
			.css(style)

	el.parents('ul').after( div )
	AjaxPageLoad(url,id,1);

}//openBox

var rightClickNone = function (settings){

		$.each(settings,function (key,val){

				//$(val).on("contextmenu", function(e){e.preventDefault();});

			});//each

};// rightClickNone

var modalDesigner = function ( divId, ref ){

	var object = formObjects.positions;
	var formItem = divId;
	var div = $('#' + formItem + '-SettingsBox');


	if ( ref ) {

			if( !div.is(':visible') ) return ;

			var inputs = div.parents('li[item="'+ formItem +'"]');

				var visb = inputs.find('div.row:first input#visible');
				var req	 = inputs.find('div.row:first input#require');
				var read = inputs.find('div.row:first input#readonly');

			if ( visb.length == 0 && req.length == 0 ) {

					AjaxPageLoad('index.cfm?fuseaction=objects.formDesigner&divId='+formItem+'&read='+read.is(':checked'),formItem+'-SettingsBox',1);

				}else {

					AjaxPageLoad('index.cfm?fuseaction=objects.formDesigner&divId='+formItem+'&visb='+visb.is(':checked')+'&read='+read.is(':checked')+'&req='+req.is(':checked'),formItem+'-SettingsBox',1);

					} // if visb.length && req.length

		}else {

			var inputs = div.parents('li');

				var visb = inputs.find('div.row:first input#visible');
				var req	 = inputs.find('div.row:first input#require');
				var read = inputs.find('div.row:first input#readonly');

			if( !div.is(':visible') ) {

					div.show();

					if ( visb.length == 0 && req.length == 0 ) {

							AjaxPageLoad('index.cfm?fuseaction=objects.formDesigner&divId='+formItem+'&read='+read.is(':checked'),formItem+'-SettingsBox',1);

						}else {

							AjaxPageLoad('index.cfm?fuseaction=objects.formDesigner&divId='+formItem+'&visb='+visb.is(':checked')+'&read='+read.is(':checked')+'&req='+req.is(':checked'),formItem+'-SettingsBox',1);

							} // if visb.length && req.length
				}else{
						div.hide();
					}// if div visible control

			} //ref

}; // modalDesigner

var openEmployee = function ( posCatId ){
	windowopen('index.cfm?fuseaction=objects.popup_get_denied_form_object&id=' + posCatId);
}; // openEmployee

var stringToLowerCase = function ( data ) {
	var Chr = {
		"Ğ": "ğ", "Ü": "ü", "Ş": "ş", "İ": "i",
		"Ç": "ç", "I": "ı",	"Ö": "ö"
		};//Chr

	for (var val in Chr){
		   data = data.split(val).join(Chr[val]);
		} // for chr
	return data.toLowerCase();

}; //	stringToLowerCase

var myPopup = function ( popname, poppage,effect ){

	var modalId = popname;
	var modalBodyId = null || popname+"-poppage";
	var modal = $('.modal#'+ modalId );
	var modalHeader = modal.find('.modal-header');
	var modalBackDrop = modal.find('.modal-backdrop');
	var modalBody = modal.find('.modal-body');


	modalBody.attr('id',modalBodyId);

	if(poppage && poppage != '')AjaxPageLoad(poppage+'&spa=1',modalBodyId);

	$('#'+modalId).toggle('slide', {direction: 'right'} , 500);
	modalBackDrop.fadeIn('fast');

	 modalHeader.find('.close').click(function(){
			modal.slideUp(300);
			modalBackDrop.fadeOut('fast');
			modalBody.removeAttr('id')
		});

	modalBackDrop.click(function(){
			modal.slideUp(300);
			$(this).fadeOut('fast');
			modalBody.removeAttr('id');
		});


}// myPopup

var nModal	= function(set) {

	if(set.content){
		var nid = set.content;
	}else{
		var nid = "nModal-"+Math.floor((Math.random() * 999));
	}

	if(set.class){
		var nClass = set.class;
	}else{
		var nClass = 'col-10 col-md-11 col-xs-12';
	}

	var nHead = set.head, nPage = set.page;
	$('<div>')
	.attr('id',nid)
	.addClass('modal hide '+nClass)
	.css("display","none")
	.append(
			 $('<div>')
				.addClass('modal-dialog')
				.append(
					$('<div>')
						.addClass('modal-content')
						.append(
							$('<div>').addClass('modal-header').append(
								'<button type="button" class="close" onclick="$(\'#'+nid+'\').remove();" data-dismiss="modal">×</button>'+
								'<i class="pull-right btnPointer catalyst-refresh" onclick="AjaxPageLoad(\''+nPage+'&spa=1\',\''+nid+'-poppage\');"></i>'+
								'<h4 class="modal-title">'+nHead+'</h4>'
								),
							$('<div>').addClass('modal-body').append('')
						 )
				),
				$('<div>').addClass('modal-backdrop').attr('onclick',"$('#"+nid+"').remove();")
	).appendTo('body');

	myPopup(nid,nPage)

}; // createModal

var alertObject = function(set) {
var id = "lineAlert-"+Math.floor((Math.random() * 999));

if(set.container == null || set.container == ""){ var container = "alertObjectContent";} else { var container = set.container;}

if(set.type=="success"){var icon ="icon-check";}
	else if(set.type=="warning"){var icon ="icon-warning";}
	else if(set.type=="info"){var icon ="icon-info-circle";}
		else{var icon ="icon-frown-o";}

if(set.type == null || set.type == "" || set.type != "success" && set.type != "warning"  && set.type != "info"  ){var type ="danger";}
	else { var type = set.type; }

 $('<div>')
	.addClass("alert alert-"+type).attr("id",id)
	.append(
		$('<button>').attr("type","button").attr('onclick','alertObjectClose(this)').addClass("close").append("×"),
		$('<span>').addClass("alertText").append(
			$('<i>').addClass(icon),//"fa-lg fa fa-warning",
			set.message
		)
			).appendTo('#'+container);
	if(set.noTop != 1)
		$("html, body").animate({scrollTop:0},500);
	function alertClose(){
		$("#"+id).remove()
	}

	if(set.closeTime)
		setTimeout(alertClose, set.closeTime)
	else
		setTimeout(alertClose, 5000);

	}; // alertObject

var alertObjectClose = function(elem) {

	$(elem).parent('div.alert').remove();

} // alertObjectClose

var oldHeigth=0;
var fsItem = 0;
var screen_status = false;
var fs = function(set) {
	fsItem = set.id;
	$('#'+fsItem).toggleClass('fsToggle');
	$('#'+fsItem).closest('.ui-draggable-box').toggleClass('ui-draggable-resize');
	$('#'+fsItem).closest('.ui-cfmodal').toggleClass('ui-cfmodal-resize');
	$('body').toggleClass('fsBody');
	/*if(screen_status == false){
		oldHeigth = $('#'+fsItem+" .portBoxBodyStandart").height() + 10;
		$('#'+fsItem+" .portBoxBodyStandart").css({"height":"calc(100% - 50px)"});
		screen_status = true;
	}else if(screen_status == true){
		$('#'+fsItem+" .portBoxBodyStandart").css({"height":oldHeigth+"px"});
		screen_status = false;
	}*/
} // FullScreen

$(document).keydown(function(e){
var code = e.keyCode || e.which;
if (code == 27) {
	$('.fsToggle').removeClass('fsToggle');
	$('.fsBody').removeClass('fsBody');
	$('#'+fsItem+" .portBoxBodyStandart").css({"height":oldHeigth+"px"});
	screen_status = false;
}
}); // FullScreen ESC

function catalystTab(){
$('#tab-head ul li:first').addClass('active');
$('#tab-content .content:first-child').show();//il contentleri aç

$('#tab-head ul li a').click(function(){
	var id = $(this).attr('href');//açılacak content in id si
	if(id)
		{
			var tab = $(this).parent("li").parents("ul.tabNav");
			$(tab).find("li").removeClass('active');//Tab linklerindeki active i isler
			$(this).parents('li').addClass('active'); // Tıklanan tab linkine active ekler
			$(tab).parents().eq(2).find('.content').hide(); // aynı ailedeki tüm tab contentleri kapatır.
			var content = $(tab).parents().eq(2).find(id).fadeIn(); // aynı ailedeki seçile id li tab contenti açar

			var datatab = id.substring(1, id.length);
			$('[data-tab="'+datatab+'"]').show();

			if(document.getElementById('sepetim')){
				var height_ = document.getElementById('sepetim').style.height;
				height_ = height_.replace('px','');
				if ( typeof(fixThead) != 'undefined' )
					fixThead(height_);
			}

		}
	return false;
});//#tab-head ul li a click function




}
var listSortState = function(elem,controllerName) {

	var listId = 'listEdit';
	$("<div>").attr('id','bigListSort').addClass('row scrollContent scroll-x3').appendTo($("#"+listId));
	var sortableSettings = {
				connectWith		: '.colNames',
				items			: 'li',
				cursor			: 'move',
				opacity			: '0.6',
				revert			: 300,
				placeholder		: 'col col-12 elementSortArea'
			}; //sortableSettings

	 $('<div>')
		.addClass( 'col col-12' )
		.attr('id','mainDiv')
		.append(function(){

			icon = '<i class="fa fa-eye-slash pull-right" style="margin-right: 7px"></i>';
			//micon = '<i class="fa fa-mobile pull-right" style="margin-right: 10px"></i>';

				$('<div>')
					.addClass('sorterHead')
					.append( $('<div style="width: 100%">').addClass('pull-left sorterElementName').append('Liste',icon) )
					.appendTo($("#bigListSort"))});
				$('<ul>')
					.addClass('sorter colNames')
					.append(function(){

						var ul = this ;

							$.ajax({ url :'WMO/pageDesigner.cfc?method=getList', data : {controllerName : controllerName}, async:false,success : function(res){ if ( res ) { data = res; } } });
							data = $.parseJSON( data );
							
							if(data['DATA'].length)
							{
								$("#listEditEx input[type='button'][class='hide']").removeClass('hide').addClass('btn blue-sharp');
								sortArray =$.parseJSON(data['DATA'][0][0]);
								
								for(i=0;i<Object.size(sortArray);i++)
								{
									fieldId = sortArray[i]['id'];
									var c = $('#'+fieldId).index();
									
									checkBox = $("<input>").attr({'type':'checkbox','id':fieldId, 'rel':'hide'}).addClass('pull-right');
									if(sortArray[i]['hidden'] == 0){
										checkBox.prop('checked',false);
										if($(window).width() > 767){
											$.each($('table tbody tr, table thead tr, table tfoot tr'), function(){
												$(this).find('th').eq(c).hide();
												$(this).find('td').eq(c).hide();
											})
										}
									}
										
									else{
										checkBox.prop('checked',true);
										$.each($('table tr'), function(){
											$(this).find('th').eq(c).show();
											$(this).find('td').eq(c).show();
										})
									}
										

									text = '';
									
									if($("#"+fieldId+' a').length)
										text = $("#"+fieldId+' a').html();
									else
										text = $("#"+fieldId).html(); 

									/*mcheckBox = $('<input style="margin-right: 10px">').attr({'type': 'checkbox', 'id': fieldId, 'rel': 'mhide'}).addClass('pull-right');
									if (sortArray[i]['mhidden'] == 0)
										mcheckBox.prop('checked', false);
									else
										mcheckBox.prop('checked', true);*/

									$('<li>')
										.append(text,checkBox)
										.addClass('colName')
										.appendTo( ul );
								}
							}
							else
							{
								
								$(elem).find("th").each(function(index,element){
									var checkBox = $("<input>").attr({'type':'checkbox','id':'th_'+index, 'rel':'hide'}).addClass('pull-right').prop('checked',true);
									
									fieldId = $(element).attr('id');
									


									if($("#"+fieldId+' a').length)
										text = $("#"+fieldId+' a').html();
									else
										text = $("#"+fieldId).html();	

									$('<li>')
										.append(text,checkBox)
										.addClass('colName')
										.appendTo( ul );
								})
							}
			}).appendTo($("#bigListSort")).sortable(sortableSettings);
}

Object.size = function(obj) {
var size = 0, key;
for (key in obj) {
	if (obj.hasOwnProperty(key)) size++;
}
return size;
};

var saveList = function(controllerName){
var data = {};
$("#bigListSort").find('li.colName').each(function(index,element){
		data[index] = {};
		data[index]['id'] = $(element).find('input[type=checkbox][rel=hide]').attr('id');
		console.log();
		if(!$(element).find('input[type=checkbox][rel=hide]').prop('checked')){
			data[index]['hidden'] = 0;
			
		}
		else
		{
			data[index]['hidden'] = 1;
			
			/* if(!$(element).find('input[type=checkbox][rel=mhide]').prop('checked'))
			data[index]['mhidden'] = 0;
		else
			data[index]['mhidden'] = 1; */
		}
	})
	$.ajax({
			url :'WMO/pageDesigner.cfc?method=menuModified',
			data : { data : JSON.stringify(data) , jsonType :5, controller : controllerName ,eventList:'sortList'},
			success : function(res){
					location.reload();
				} // success

		}); // ajax
}
var delList = function(controllerName){
	$.ajax({
			url :'WMO/pageDesigner.cfc?method=delModified',
			data : { controllerName : controllerName, jsonType : 5},
			success : function(res){
					location.reload();
				} // success

		}); // ajax
}

/*$( document ).on( "swipeleft swiperight scroll", "body", function( e ) {
	if( $(window).width() <= 768  ){
		if(!e.target.closest('.ListContent, .scrollContent,div[class*="scroll"]')) {
			if ( e.type === "swipeleft"  ) {
				if ( $('.leftBar').hasClass('push') ){
					$('.page-logo').trigger('click');
					$('.leftBar input#leftMenuSearch ').blur();
				}
			} else if ( e.type === "swiperight" ) {
					openPanel().leftPanel('push'); // sidebar left open function
					$('.leftBar input#leftMenuSearch ').focus();
			}
		}
	}
});*/

var searchDetailContentButton = function(e){
	$(e).closest(".searchInput").next('.searchDetailContent').toggle(200);
};

var saveFav = function(elementId,userid){
		$.ajax({ url :'WMO/utility.cfc?method=addFavorite', data : {elementId : elementId}, async:false,success : function(res){
			data = $.parseJSON( res );
				if(data['DATA'].length)
					$("section.favoriteBar").removeClass('hide');
				if(!$("section.favoriteBar").find('ul li[value="'+elementId+'"]').length)
				{
					if(data['DATA'][0][3] == 1)
						var link_ = $("<a>").attr({'href':data['DATA'][0][1],'target':'_blank'}).html(data['DATA'][0][2]);
					else
						var link_ = $("<a>").attr('href',data['DATA'][0][1]).html(data['DATA'][0][2]);
					var iLink = $("<i>").addClass('fa fa-circle');
					$("section.favoriteBar ul").append($("<li>").val(elementId).append(iLink).append(link_));
					$("div[value='"+elementId+"'] span").removeAttr('onclick').attr('onclick','delFav("'+elementId+'","'+userid+'")');
					$("div[value='"+elementId+"'] i").removeClass().addClass('icon-minus');
				}
			}
		});
		if (typeof(Storage) != "undefined") {//browser'ın storage özelliği var mı diye kontrol ediyor.(Check browser support)
			var local_favlist = $("section.favoriteBar ul").html();
			localStorage.setItem("favoriteBar_"+userid, local_favlist);//local storage'e html'i yüklüyor.
		}
	}
var delFav = function(elementId,userid){
		$.ajax({ url :'WMO/utility.cfc?method=delFavorite', data : {elementId : elementId}, async:false,success : function(res){
				$("section.favoriteBar ul li[value='"+elementId+"']").remove();
				if (typeof(Storage) != "undefined") {//browser'ın storage özelliği var mı diye kontrol ediyor.(Check browser support)
					var local_favlist = $("section.favoriteBar ul").html();
					localStorage.setItem("favoriteBar_"+userid, local_favlist);//local storage'e html'i yüklüyor.
					if(local_favlist == ""){
						$("section.favoriteBar").addClass('hide');//eğer local fav list'in içerisi boşsa favori alanını gizler.
					}
				}
				$("div[value='"+elementId+"'] span").removeAttr('onclick').attr('onclick','saveFav("'+elementId+'","'+userid+'")');
				$("div[value='"+elementId+"'] i").removeClass().addClass('icon-pluss');
				data = $.parseJSON( res );
				if(!data['DATA'].length)
					$("section.favoriteBar").addClass('hide');
			}
		});
	}
var loadFav = function(amount,userid){
	$("section.favoriteBar ul").empty();	
	$.ajax({ url :'WMO/utility.cfc?method=getFavorite',success : function(res){
		data = $.parseJSON( res );
			if(data['DATA'].length)
				$("section.favoriteBar").removeClass('hide');
			for(i=0;i<data['DATA'].length;i++)
			{
				if(data['DATA'][i][3] == 1)
					var link_ = $("<a>").attr({'href':data['DATA'][i][1],'target':'_blank'}).html(data['DATA'][i][2]);
				else
					var link_ = $("<a>").attr('href',data['DATA'][i][1]).html(data['DATA'][i][2]);
				var iLink = $("<i>").addClass('fa fa-circle');
				$("section.favoriteBar ul").append($("<li>").val(data['DATA'][i][0]).append(iLink).append(link_));
			}
		}
	});
	
}


function check(e, table, indis){
//console.log(indis);
var table = $('table#'+$(table).attr("id"));
if(e.classList.contains("active")){
	if($(window).width() < 767){
		table.find('tr').each(function(){
			if($(this).attr("indis") == indis){
				$(this).removeClass("hidden");
			}
		});
	}
	else{
		table.find('thead tr:last-child, tbody tr, tfoot tr').each(function(){
			$(this).find('th').eq(indis).removeClass("hidden");
			$(this).find('td').eq(indis).removeClass("hidden");
		});
	}
	
	e.classList.add("passive");
	e.classList.remove("active");
}
else{
	if($(window).width() < 767){
		table.find('tr').each(function(){
			if($(this).attr("indis") == indis){
				$(this).addClass("hidden");
			}
		});
	}
	else{
		table.find('thead tr:last-child, tbody tr, tfoot tr').each(function(){
			$(this).find('th').eq(indis).addClass("hidden");
			$(this).find('td').eq(indis).addClass("hidden");
		});
	}
	e.classList.add("active");
	e.classList.remove("passive");
}
}

/* Popupları draggable box olarak açılması için openBoxDraggable ve LoadPopupBox fonksiyonları oluşturuldu! E.Y*/
function openBoxDraggable(url, modal_id = "", size = "", form){
	var uniqueId = modal_id == '' ? Math.floor(Math.random() * 999999999999999) : modal_id;
	if($('#popup_box_' + uniqueId + '').length == 0){ $('<div>').addClass("ui-draggable-box" + " " + size).attr({"id" : "popup_box_" + uniqueId + ""}).appendTo($('body')); }
	$('#popup_box_' + uniqueId + '').css({'display' : 'block', 'visibility' : 'visible'});
	$("body").addClass("modal-opened");
	url += !url.includes('&modal_id=') ? "&draggable=1&modal_id=" + uniqueId + "" : "&draggable=1";
	if( form != undefined ){
		var data = new FormData( form[0] );
		$("#working_div_main").css({"z-index":"99999999"}).show();
		AjaxControlPostData( url, data, function( response ){ $("#popup_box_" + uniqueId + "").html( response ); $("#working_div_main").css({"z-index":"9999999"}).hide(); });
	}else AjaxPageLoad(url, "popup_box_" + uniqueId + "");
	return false;
}
function closeBoxDraggable( modal_id = "", box_id = "" ){
	$('#popup_box_' + modal_id + '').remove();
	$("body").removeClass("modal-opened");
	if( box_id != '' ){
		if( $("#"+ box_id +" i.catalyst-refresh").length >0 ) $("#"+ box_id +" i.catalyst-refresh").parent('a').click();
		else if ( $("#"+ box_id +" span.catalyst-refresh").length >0 ) $("#"+ box_id +" span.catalyst-refresh").click();
		else if ( $("#"+ box_id +" a#wrk_search_button").length >0 ) $("#"+ box_id +" a#wrk_search_button").click();
	}
}
function loadPopupBox(form_name, modal_id = ""){
	var form = $('form[name = ' + form_name + ']');
	openBoxDraggable( decodeURIComponent( form.attr( "action" ) ).replaceAll("+", " "), modal_id, "", form );
	return false;
}
/* Cf_Box Modal - depency -> unique id */
function cfmodal(action, id, option){
	$('#warning_modal').fadeIn();
	$('.ui-cfmodal-close').trigger("click");
	if( option != undefined ){
		if( option.html != undefined && option.html != '' ) $( "#"+id ).html(option.html);
		if( option.element_id != undefined && option.element_id != '' ) $( "#"+id ).html($('#'+option.element_id+'').html());
	}else AjaxPageLoad(action, id);
	
}

var cfmodalx = function(params){
    if(params.e == 'open'){
        $('#'+params.id).fadeIn();
        $('#unique_'+params.id+'_box').fadeIn();
    }else if(params.e == 'close'){
        $('#'+params.id).fadeOut();
        $('#unique_'+params.id+'_box').fadeOut();
    }
}

function getTourList(getObject){
	$.ajax({
		url :'/wex.cfm/tour/getlist',
		method: 'post',
		contentType: 'application/json',
		dataType: "json",
		data : JSON.stringify(getObject),
		success :  function(response){
			var getArr = response;			
			var colors = ["#cbf0f8", "#f28b82", "#d7aefb", "#f3f6255e","#32c5d2", "#ff9800", "#4db3a2"];			
			$.each(getArr, function(i,v){
			   var getArrPars = JSON.parse(v.HELP_TOPIC);
			   var news = "";
			   if(v.NEWS == 1) news = "show"; else news ="none";
			   /* console.log(getArrPars); */
			   var newElP; 
			   var newElPin = $('<div>').addClass('tour_pin tour_pin_list tour_pin'+v.HELP_ID+'').attr({title: v.HELP_HEAD, onclick: 'openBoxDraggable("index.cfm?fuseaction=objects.widget_loader&widget_load=updWorktips&is_box=1&box_title=Tips Güncelle&worktips_id=' + v.HELP_ID + '","","ui-draggable-box-medium")'});
			   newElPin.append("<i class='fa fa-lightbulb-o'></i>");
				var newElBox = $('<div>').addClass('tour_box tour_box'+v.HELP_ID+'');
				var newElForm = $('<form>').attr({"id" : "upd_tip"+v.HELP_ID, "name" : "upd_tip"+v.HELP_ID});
				var newElId = $('<input>').attr({"type" : "hidden", "name" : "help_id", "id" : "help_id", "value" : v.HELP_ID});
				var newElTitle = $('<div>').addClass('tour_box_title').append('<h1  id="help_head" contenteditable="false"><i class="fa fa-bullhorn" style="color:red;display:'+ news +'"></i> '+ v.HELP_HEAD +'</h1>');
				var newElText = $('<div>').addClass('tour_box_text').append(newElP).append('<p name="help_topic" id="help_topic"> '+ getArrPars.options.el_content +'</p>').attr("contenteditable","false");
				var newElIcon = $('<div>').addClass('tour_box_icon').append('<p></p><ul></ul>');

				newElForm.append(newElTitle);
				newElForm.append(newElId);
				newElForm.append(newElText);
				newElForm.append(newElIcon);
				newElBox.append(newElForm);
				/* $('body').append(newElBox); */
				$('.help_tour_wrapper_pin_item').append(newElPin)
				$('#help_tour_wrapper').append(newElBox);
				
				$( '.close'+v.HELP_ID ).click(function() {
					$('.tour_box'+v.HELP_ID).hide();
				});
				$('#update_tip'+v.HELP_ID).click(function(){
					var formObjects = {};
				
					$.each($('form[name=sessionObj]').serializeArray(),function(i, v) {
						formObjects[v.name] = v.value;
					});
					formObjects.help_id = $('form[name=upd_tip'+v.HELP_ID+'] #help_id').val();
					formObjects.help_head = $('form[name=upd_tip'+v.HELP_ID+'] #help_head').text();					
					var el_answer = $('form[name=upd_tip'+v.HELP_ID+'] #help_topic').text();
				
					var answer = {"active": true, options : {"left":getArrPars.options.left, "top":getArrPars.options.top, "el_id":getArrPars.options.el_id, "el_content":el_answer, "el_node":getArrPars.options.el_node}};
					formObjects.help_topic = JSON.stringify(answer);
					formObjects.is_new = '';
					
					if ($('form[name=upd_tip'+v.HELP_ID+'] #is_new').is(':checked')) {formObjects.is_new = 1;}

					$.ajax({
						url :'/wex.cfm/tour/update',
						method: 'post',
						contentType: 'application/json; charset=utf-8',
						dataType: "json",
						data : JSON.stringify(formObjects),
						error :  function(response){
							if(trim(response.responseText) === "Ok"){
								alert("Yardım Notu Guncellendi. Yönlendiriliyorsunuz..");
								location.reload();
							}
							else{
								alert("Bir hata oluştu!");
								location.reload();
							}
						}
					});
				});

				$('#del_tip'+v.HELP_ID).click(function(){
					var formObjects = {};		
					formObjects.help_id = $('form[name=upd_tip'+v.HELP_ID+'] #help_id').val();
									
					$.ajax({
						url :'/wex.cfm/tour/delete',
						method: 'post',
						contentType: 'application/json',
						dataType: "json",
						data : JSON.stringify(formObjects),
						error :  function(response){
							if(trim(response.responseText) === "Ok"){
								alert("Yardım Notu Silindi. Yönlendiriliyorsunuz..");
								location.reload();
							}
							else{
								alert("Bir hata oluştu!");
								location.reload();
							}
						}
					});
				});
			
			});
		}	
	}).done(function(){
		var index = 0;
		$('#help_tour_next').click(function(){
			index++;
			if(index < $('.tour_box').length){
				$('.tour_box').hide();
				$('.tour_box').eq(index).fadeIn();
			}else index--;
		})
		$('#help_tour_prev').click(function(){
			if(index != 0){
				index--;
				$('.tour_box').hide();
				$('.tour_box').eq(index).fadeIn();
			}
		})
	})
}

function getTourListNews(getObject){
	$.ajax({
		url :'/wex.cfm/tour/getlists',
		method: 'post',
		contentType: 'application/json',
		dataType: "json",
		data : JSON.stringify(getObject),
		success :  function(response){
			var getArr = response;			
			var colors = ["#cbf0f8", "#f28b82", "#d7aefb", "#f3f6255e","#32c5d2", "#ff9800", "#4db3a2"];			
			$.each(getArr, function(i,v){
			   var getArrPars = JSON.parse(v.HELP_TOPIC);
			   var news = "";
			   if(v.NEWS == 1) news = "show"; else news ="none";
			   /* console.log(getArrPars); */
			   var newElP; 
				var newElBox = $('<div>').addClass('tour_box_news tour_box'+v.HELP_ID+'');
				var newElForm = $('<form>').attr({"id" : "upd_tip_news"+v.HELP_ID, "name" : "upd_tip_news"+v.HELP_ID});
				var newElId = $('<input>').attr({"type" : "hidden", "name" : "help_id", "id" : "help_id", "value" : v.HELP_ID});
				var newElTitle = $('<div>').addClass('tour_box_title').append('<h1  id="help_head" contenteditable="false"><i class="fa fa-bullhorn" style="color:red;display:'+ news +'"></i> '+ v.HELP_HEAD +'</h1>');
				var newElText = $('<div>').addClass('tour_box_text').append(newElP).append('<p name="help_topic" id="help_topic"> '+ getArrPars.options.el_content +'</p>').attr("contenteditable","false");
				var newElIcon = $('<div>').addClass('tour_box_icon').append('<p></p><ul></ul>');

				newElForm.append(newElTitle);
				newElForm.append(newElId);
				newElForm.append(newElText);
				newElForm.append(newElIcon);
				newElBox.append(newElForm);
				$('#help_tour_wrapper_news').append(newElBox);
				
				$('#update_tip_news'+v.HELP_ID).click(function(){
					var formObjects = {};
				
					$.each($('form[name=sessionObj]').serializeArray(),function(i, v) {
						formObjects[v.name] = v.value;
					});
					formObjects.help_id = $('form[name=upd_tip_news'+v.HELP_ID+'] #help_id').val();
					formObjects.help_head = $('form[name=upd_tip_news'+v.HELP_ID+'] #help_head').text();					
					var el_answer = $('form[name=upd_tip_news'+v.HELP_ID+'] #help_topic').text();
				
					var answer = {"active": true, options : {"left":getArrPars.options.left, "top":getArrPars.options.top, "el_id":getArrPars.options.el_id, "el_content":el_answer, "el_node":getArrPars.options.el_node}};
					formObjects.help_topic = JSON.stringify(answer);
					formObjects.is_new = '';
					
					if ($('form[name=upd_tip_news'+v.HELP_ID+'] #is_new').is(':checked')) {formObjects.is_new = 1;}

					$.ajax({
						url :'/wex.cfm/tour/update',
						method: 'post',
						contentType: 'application/json; charset=utf-8',
						dataType: "json",
						data : JSON.stringify(formObjects),
						error :  function(response){
							if(trim(response.responseText) === "Ok"){
								alert("Yardım Notu Guncellendi. Yönlendiriliyorsunuz..");
								location.reload();
							}
							else{
								alert("Bir hata oluştu!");
								location.reload();
							}
						}
					});
				});

				$('#del_tip_news'+v.HELP_ID).click(function(){
					var formObjects = {};		
					formObjects.help_id = $('form[name=upd_tip_news'+v.HELP_ID+'] #help_id').val();
									
					$.ajax({
						url :'/wex.cfm/tour/delete',
						method: 'post',
						contentType: 'application/json',
						dataType: "json",
						data : JSON.stringify(formObjects),
						error :  function(response){
							if(trim(response.responseText) === "Ok"){
								alert("Yardım Notu Silindi. Yönlendiriliyorsunuz..");
								location.reload();
							}
							else{
								alert("Bir hata oluştu!");
								location.reload();
							}
						}
					});
				});
			
			});
		}	
	}).done(function(){
		var index = 0;
		$('#help_tour_next_news').click(function(){
			index++;
			if(index < $('.tour_box_news').length){
				$('.tour_box_news').hide();
				$('.tour_box_news').eq(index).fadeIn();
			}else index--;
		})
		$('#help_tour_prev_news').click(function(){
			if(index != 0){
				index--;
				$('.tour_box_news').hide();
				$('.tour_box_news').eq(index).fadeIn();
			}
		})
	})
}

/* Ready Function */
$(function(){

$("*").click(function( e ){
	if( e.target.id == 'help_topic' || e.target.id == 'help_head' || e.target.id == 'is_new' || e.target.id.includes('del_tip') || e.target.id.includes('update_btn')) $(".tour_box_icon").css('visibility','visible');
	else $(".tour_box_icon").css('visibility','hidden');
})


$('.mega-menu').hover(function(){
	$('.interaction_menu').show();
}, function(){
	$('.interaction_menu').hide();
})

$('#help_tour_add, #help_tour_add_mobile').click(function(){
	$('#help_tour_modal').show();
})

/* Page Designer Alert */
$('.ui-cfmodal-close').click(function(){
	$('.ui-cfmodal__alert').fadeOut('fast', function(){
		$('.ui-cfmodal__alert .required_list li').remove();
	});
	
})

/* Ajax List,Grid List Sürükle Bırak Sırala*/
if($('table[sort="true"]').length > 0){
	$('table[sort="true"]').dragtable({
		dragaccept: '.drag-enable',
		dragHandle: '.table-handle',
	}).tablesorter();
	$( 'table[sort="true"] th' ).each(function( index , element ) {
		if($(this).hasClass('header_icn_none'))
		{
			$(this).unbind('click');
		}
		else if ($(this).hasClass('header_icn_text')) 
		{
			$(this).unbind('click');		
		}
	});
}

//Listeleme Ekranları için yazılmıştır.
//Baskette hata olduğu için geçici süreliğine kapatıldı.
var event = (typeof(document.getElementById('controllerEvents')) != 'undefined' && document.getElementById('controllerEvents') != null) ? document.getElementById('controllerEvents').value : '';
	if(event == "list"){
		var th = $('table thead tr th');
			$.each(th, function(){
				if($(this).attr("id") == undefined){
				$(this).attr("id","th_"+$(this).index());
			 }
		})
	}

$('.ui-list li a i.fa-chevron-down').click(function(){
	$(this).closest('.ui-list-right').toggleClass("ui-list-right-open");
	$(this).closest('li').find("> ul").fadeToggle();
});

$('.portHeadLightMenu > ul > li > a').click(function(){
	$('.portHeadLightMenu > ul > li > ul').stop().fadeOut();
	$(this).parent().find("> ul").stop().fadeToggle();
});


/* Ajax List,Grid List Gizle Göster*/
$('.table_column_list').click(function(){
	var table = $(this).parents('.boxRow').find('table');
	if(table.css("display") != "none"){
		var table_id = table.attr("id");
		var table_list_container = $(this).parents('.boxRow').find('#table_list_container');
		if($(window).width() < 767){
			var table_rep = table.find('tr:last-child').attr("indis");
			if(!table_list_container.find('li').length){
				for(var j=0; j<=table_rep; j++){
					var data = table.find('tr').eq(j).find("td").eq(0).html();
					var indis = table.find('tr').eq(j).attr("indis");
					table_list_container.append('<li><input type="checkbox" onchange="check(this,'+ table_id +', '+ indis + ')">'+ data +'</li>');
					table_list_container.find('.table-handle').remove();
				}
			}
		}
		
		else{
			var table_th = table.find('thead tr:last-child th')
			if(!table_list_container.find('li').length){
				$.each(table_th, function(i){
					var data = $(this).html();
					if($(this).find('.tablesorter-header-inner').length){
						if($(this).find('.tablesorter-header-inner').text() != ""){
							var indis = $(this).index();
							table_list_container.append('<li><input type="checkbox" onchange="check(this,'+ table_id +', '+ indis + ')">'+ data +'</li>');
							table_list_container.find('li').eq(i).find('.table-handle').remove();
						}
					}
					else{
						var indis = $(this).index();
							table_list_container.append('<li><input type="checkbox" onchange="check(this,'+ table_id +', '+ indis + ')">'+ data +'</li>');
							table_list_container.find('li').eq(i).find('.table-handle').remove();
					}
					
				});
			}
		}
	}
	
});

$('.iconL > a').click(function(){
	var id = $(this).attr('id');
	var	table = $(this).parents('table');
	$(this).toggleClass("iconL_open");
	$.each(table.find('tr'), function(){
		if($(this).attr("id") === id){
			$(this).toggle();
		}
	})
})

/* Daha fazla */
$('#ui-otherFileBtn').click(function(){
	$(this).parents('.ui-form-list').find(".ui-otherFile").stop().slideToggle();
	$(this).parents('.ui-form-list').find('> .form-group > .ui-btn-green').toggle();
	$(this).toggleClass("ui-otherFileBtn-open");
 });

 $('.ui-customTooltip ul li').hover(function(){
	 $(this).find('span').stop().fadeIn();
 }, function(){
	 $(this).find('span').stop().fadeOut();
 });

/* $(document).on("click", function(event){
	var $trigger = $('.portHeadLightMenu > ul > li > a');
	if($trigger !== event.target && !$trigger.parent().has(event.target).length){
		$trigger.parent().find("> ul").stop().fadeOut();
	}            
}) */

var li = $('li.ui-dropdown');
$.each(li, function(){
	if($(this).find('> ul li').length == 0){
		$(this).hide();
	}
});

/* depency -> Unique id */
if($(window).width() < 568){
	if($('#basketIframe').length == 0 && location.href.indexOf("ch.list_company_extre") < 0 && location.href.indexOf("myhome.list_my_expense_requests") < 0 && location.href.indexOf("myhome.allowance_expense") < 0){
		var elem = $('table.ajax_list, table.ui-table-list'), id, elem_tr = [];
		if(elem.length > 0){
			$.each(elem, function(i){
				id = elem.eq(i).attr("id");
				$.each(elem.eq(i).find('tbody tr'), function(i){
					for(var k=0; k<$(this).parents('table').find('thead th').length; k++){
						if($(this).parents('table').find('thead th').eq(k).html() != undefined && $(this).find('td').eq(k).html() != undefined){
							elem_tr.push({"id":id, "indis":k, "isCheck":$(this).parents('table').find('thead th').eq(k).find("input[type='checkbox']").length, "mobil_th":$(this).parents('table').find('thead th').eq(k).find("i, img").attr("title"),"th":$(this).parents('table').find('thead th').eq(k).html(), "td":$(this).find('td').eq(k).html()});
						}
					}  
				});  
				if($(window).width() < 568){
					var newTable = $('<table id="mobil'+id+'" class="ajax_list"></table>');
					elem.eq(i).before(newTable);
					/*elem.eq(i).parent().prepend('<ul class="ui-icon-list flex-right"><li><a id="standart_design" href="javascript://"><i class="fa fa-laptop"></i></a></li><li><a id="mobil_design" href="javascript://"><i class="fa fa-tablet"></i></a></li></ul>'); */
				}
			})
			$.each(elem_tr, function(i){
				var seperator = $('#'+this.id).find('thead th').length;
				if(i != 0 && this.indis === 0){
					$('#mobil'+this.id).append('<tr class="ui-line-bg"><td colspan="'+ seperator +'"></td></tr>');
					$('#mobil'+this.id).append('<tr class="ui-line"><td colspan="'+ seperator +'"></td></tr>');
					$('#mobil'+this.id).append('<tr class="ui-line-bg"><td colspan="'+ seperator +'"></td></tr>');
					if(this.mobil_th != undefined){
						$('#mobil'+this.id).append('<tr indis="'+this.indis+'"><td style="background-color:#f9f9f9;">'+ this.mobil_th +'</td><td>'+ this.td +'</td></tr>');
					}
					else if(this.isCheck > 0){
						$('#mobil'+this.id).append('<tr indis="'+this.indis+'"><td style="background-color:#f9f9f9;">Seç</td><td>'+ this.td +'</td></tr>');
					}
					else{
						$('#mobil'+this.id).append('<tr indis="'+this.indis+'"><td style="background-color:#f9f9f9;">'+ this.th +'</td><td>'+ this.td +'</td></tr>');
					}
				}
				else{
					if(this.mobil_th != undefined){
						$('#mobil'+this.id).append('<tr indis="'+this.indis+'"><td style="background-color:#f9f9f9;">'+ this.mobil_th +'</td><td>'+ this.td +'</td></tr>');
					}
					else if(this.isCheck > 0){
						$('#mobil'+this.id).append('<tr indis="'+this.indis+'"><td style="background-color:#f9f9f9;">Seç</td><td>'+ this.td +'</td></tr>');
					}
					else{
						$('#mobil'+this.id).append('<tr indis="'+this.indis+'"><td style="background-color:#f9f9f9;">'+ this.th +'</td><td>'+ this.td +'</td></tr>');
					}
				}
				
			});
		}
	}
}

$('.leftBar .search').click(function(){

		openPanel().leftPanel('push'); // sidebar left open function
		if($(window).width>1000){
			$('.leftBar input#leftMenuSearch ').focus();
		}

	}); // click .leftBar .search


catalystTab();/*TAB Func*/

$(".portHead ul.tabNav li a").click(function(){
	var id = $(this).attr('href');//açılacak content in id si
	var tab = $(this).parent("li").parent("ul.tabNav");
	$(tab).find("li").removeClass('active');//Tab linklerindeki active i isler
	$(this).parent().addClass('active'); // Tıklanan tab linkine active ekler
	$(tab).parents().eq(2).find('.content').hide(); // aynı ailedeki tüm tab contentleri kapatır.
	var content = $(tab).parents().eq(2).find(id).fadeIn(); // aynı ailedeki seçile id li tab contenti açar
	return false;
});//#portHead ul li a click function
/*TAB END*/

	/* Tooltip */
	$(".input-group-tooltip").mouseover(function() {
		$( this ).closest("div.input-group").css("position","relative");
		$( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().show();
	}).mouseout(function() {
		$( this ).closest("div.input-group").css("position","initial");
		$( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().hide();
	});

});//ready