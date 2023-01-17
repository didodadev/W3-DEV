// global nesneler
var printObject	= {}; // printObject

/**

	printElement		:
	PrintPagesize		:
	savePrint			:
	itemDelete			:
	itemActive			:
	createTemplate		:
	printPage			:
	tableSettings		:
	headerFixed			:

	//Oluşturan : Emrah Kumru

**/

$.when( $.getScript( "/JS/assets/lib/jquery-ui/jquery-ui.js" ), $.getScript( "/JS/assets/lib/jquery-print/jquery-print.js" ) ).fail(function(e){ console.log (e);});

var printElement = function (settings) {
	//console.log (settings);

	"use strict";

		if (settings.jSon){
		
				var json = $.parseJSON( settings.jSon );
				$.each(json, function(k,v){ printObject[k] = v; }); //each
			
			}else{
				
					printObject['page'] = [];
					printObject['items'] = [];
					printObject['tables'] = { style:[], items:[], rowCount:null };
					
					var c = { type : 0, rotate : 0, fixHeader : false ,divs:{ pageHeader : {},pageBody : {},pageFooter : {} } ,style:{ width : 210, height : 297, padding : 0,fontFamily: 0, fontSize:0, textDecoration : false, fontStlye : false, fontWeight : false } };
					printObject.page.push(c);
			
				} // if

		var columnName		= 'column',
			modalId			= 'printPanel',
			activeClass		= 'active',
			handleEl		= '.form-group',
			columnClass		= '.' + columnName,
			columnId		= '#' + columnName,
			columnCount		= $(columnClass).length,
			modalPanel 		= $('*').find('div#' + modalId ),
			modalBody		= modalPanel.find('.modal-body'),
			modalFooter		= modalPanel.find('.modal-footer'),
			page 			= modalBody.find('#page'),
			elements		= modalBody.find('#elements'),
			lists			= modalBody.find('#lists'),
			elementStyle	= modalPanel.find('#elemetStyle'),
			pageHeader		= page.find('div#pageHeader'),
			pageBody		= page.find('div#pageBody'),			
			pageFooter		= page.find('div#pageFooter'),
			printItem	 	= 'printItem',
			dragElClass		= 'dragEl',
			
			t	= modalPanel.find('select#type'),
			r	= modalPanel.find('select#rotate'),
			w	= modalPanel.find('input#width'),
			h	= modalPanel.find('input#height'),
			pd	= modalPanel.find('input#padding'),
			hf	= modalPanel.find('input#headerFixed'),
			bg	= modalPanel.find('input#backgroundFile'),
			
			f	= elementStyle.find('select#font-family'),
			s	= elementStyle.find('select#font-size'),
			b	= elementStyle.find('button#font-bold'),
			i	= elementStyle.find('button#font-italic'),
			u	= elementStyle.find('button#font-underline'),
			
			aJ	= elementStyle.find('button#align-justify'),
			aR	= elementStyle.find('button#align-right'),
			aC	= elementStyle.find('button#align-center'),
			aL	= elementStyle.find('button#align-left'),
			
			o	= printObject;
			
		/*Template Create*/
		
		$.each([ pageHeader, pageBody, pageFooter, elements, lists ], function(){
	
						var divs = $(this).find('.' + printItem),
							ul	 = $(this).find('ul');	
						
						if (divs) divs.remove();
						if(ul) ul.remove();
			
			});// each
	
		$('<ul>')
			.addClass('hoverList')
			.append(function() {
				
				var ul = this ;

				if (settings.bodyList) {
								
						var b	= settings.bodyList;
				
						$.each(b.split(',').sort(function(a,b){ 
						
								var a1 = a.split('$')[1];
								var b1 = b.split('$')[1];
						
									if(a1 == b1) return 0;
									return a1 > b1 ? 1 : -1;
						
								 }), function(k,v){				
									//console.log(k,v);
									
									var d = v.split('$');
									var attr = {'id' : 'item-' + d[0] , item : d[0], response : v };
									
									$('<li>')
										.attr(attr)
										.addClass('handle')
										.append( $('<i>').addClass('icon-chevron-right'),d[1].toLowerCase())
										.appendTo( ul );
								
								}); // each
						
				}else {
					
						for ( var i = 1 ; i <= columnCount ; i ++ ) {
								
							var findDiv = $( columnId + '-' + i ).find(handleEl+':visible');
						
							$.each(findDiv, function (key,val) {
									//console.log (val);
									
									var _el			= $(val);
									var divId		= _el.attr('id');
									var divLabel	= _el.find('label').text();			 		 			 
									var elSel		= 'input:visible, select:visible, textarea:visible';
									var formEl		= _el.find(elSel);
									var formElId	= formEl.attr('id');
											
										var attr = {'id' : divId ,'item' : formElId };
				
										$('<li>')
											.attr(attr)
											.addClass('handle')
											.append( $('<i>').addClass('icon-chevron-right'),divLabel)
											.appendTo( ul );
				
								}); // each findDiv
										
						} // for
						
						
						} //if	
					
				$('<li>')
					.attr({'id': 'item', item : 'personal-Text'})
					.addClass('handle')
					.append( $('<i>').addClass('icon-chevron-right'), 'Text') // dil objesine alınacak
					.appendTo( ul );		
						
				
			})
			.appendTo( elements )
			.sortable( { revert :300 , cursor: 'move',opacity : '0.6' } );
		
		if (settings.rowsList ){
				
				$('<ul>')
					.addClass('hoverList')
					.append( function(){
					
							$('<li>')
								.attr('data','table-list')
								.addClass('handle li-tree')
								.append(function(){
								
									$(this).append($('<i>').addClass('icon-chevron-right'),'Tablo');
									
									$('<ul>')
										.append(function(){
											
												var ul = this;
												
												$.each(settings.rowsList.split(','), function(k,v){
														
														var n = v.split('$');
														
														$('<li>')
															.attr({
																'id' : 'table-item-' + n[0],
																'item' : n[0],
																'response' : v
																})
															.append(n[1].toLowerCase(), $('<input>').attr({'type':'checkbox', 'onClick': 'tableSettings("columnVisb",this)'}))
															.appendTo(ul);
													}); // each
											
											})
										.appendTo(this);
								
								})
								.appendTo( this );
					})
					.appendTo( lists )
					.sortable( { revert :300 , cursor: 'move',opacity : '0.6' } );
				
				} // if
					
		$.each([ pageHeader, pageBody, pageFooter ], function(){
					
						$(this).droppable({
						  accept : 'li',
						  activeClass: "ui-state-default",
						  hoverClass: "ui-state-hover",
						  drop: function( event, ui ) {
							
							
								var uiEl	= $( ui.helper ),
									elId	= uiEl.attr('id'),
									control = $(this).find('div#' + elId );
							
								if ( control.length > 0 ) { return; }
							
								var elName	= uiEl.text(),
									elAttr	= uiEl.attr('item'),
									elRes	= uiEl.attr('response') || null,
									elData	= uiEl.attr('data') || null,
									divId	= $(this).attr('id'),
									elPers	= (elAttr) ? elAttr.indexOf('personal') : null,
									oL		= 360,
									oT		= 102,
									left	= ui.offset.left - $(this).offset().left, 
									top		= ui.offset.top - $(this).offset().top;
								
									if ( left < 0 )  left = 0;
									if ( top  < 0 ) top = 0 ;
													
								var css = {	left : left, top : top };

								if( elPers >= 0 ) {
										
										var rnd = Math.floor((Math.random() * 100) + 1);
										elId	= elId + '-' + rnd; 
										elAttr	= elAttr + '-' + rnd;
								
									} // if 
								
								if (!elData ){
												
										$('<div>')
											.addClass([printItem, dragElClass].join(' '))
											.css(css)
											.attr({
												'id' :  elId ,
												'item' : elAttr,
												'type' : 'item',
												'onClick': 'itemActive(this,event)'
												})
											.append(function(){
												
													( elPers < 0 ) ? $(this).append( elName ) : $('<textarea>').appendTo(this);
													$('<i>').addClass('icon-remove position-ne').attr('onClick','itemDelete(this,event)').appendTo(this);				
												
												})
											.appendTo(this)
											.resizable({containment: "parent"})
											.draggable({containment: "parent"});
											
										var item = { item : elAttr, id : elId, name : elName, response : elRes, data : null, parentDiv : null , style : { left: 0, top : 0, height : 0, width : 0, fontFamily: 0, fontSize:0, textDecoration : false, fontStlye : false, fontWeight : false, align : null } };
														
										o.items.push(item);
									
										} // if
										
								if (elData && divId === pageBody.attr('id') )	{
										
										var control = $(this).find('table[data="table-list"]'),
											rowItems = uiEl.find('ul > li '),
											visbLen = rowItems.find('input[type="checkbox"]:checked');
									
										if ( control.length > 0 ) return;
										
										var r	= settings.rowsList;
										var css = {"min-height" : "200px", left : left, top : top  };	
									
										$('<table>')
											.addClass([printItem].join(' '))
											.css(css)
											.attr('data', 'table-list')
											.append(function(){
												
												var table = this;
												
												o.tables.style.push({ left: 0, top : 0, height : 0, width : 0, fontFamily: 0, fontSize:0, textDecoration : false, fontStlye : false, fontWeight : false });
		
												o.tables.rowCount = 1;
												
												$('<thead>')	
													.append(
														$('<tr>')
															.append(function() {	
														
																 var tr = this;
																 
																 $.each(r.split(','), function(k,v){				
																		//console.log(k,v);
																		
																			var d	 = v.split('$'),
																				attr = {'id' : 'table-item-' + d[0] , item : d[0], response : v, 'type' : 'table-item','onClick': 'itemActive(this,event)' },
																				i 	 = $.grep(rowItems, function (v){ return $(v).attr('id') ===  'table-item-' + d[0] ;}),
																				input = $(i).find('input[type="checkbox"]');

																				if (!input.get(0).checked) return ;
																			
																			$('<th>')
																				.attr(attr)
																				.append(d[1],$('<i>').addClass('icon-remove position-ne').attr('onClick','itemDelete(this,event)'))
																				.appendTo(tr)
																				.resizable();
																			
																			var item = { item : d[0], id : 'table-item-' + d[0] , name : d[1], response : v, pageSum : false, style : { height : 0, width : 0, fontFamily: 0, fontSize:0, textDecoration : false, fontStlye : false, fontWeight : false, align : null } };
																		
																			o.tables.items.push(item);
																			
																		}); // each
														})
													
													)
													.appendTo(this);
													
													$('<tbody>')	
														.append(
																												
															$('<tr>').append(function(){
																var _tr = this;

																for ( var i = 0 ; i < visbLen.length; i++ ) {
																	
																			 $('<td>').append(' ').appendTo(_tr);
																	
																	
																	}// for
																
																})
														)	
														.appendTo(this);
														
												})
											.appendTo(pageBody)
											.resizable({containment: "parent"})
											.draggable({containment: "parent"});
											
																		
										} // if
						
						  }// drop
			  });
				  
				  }); // each
		  
		pageHeader.resizable({
						containment: 'parent',
						handles: "s,e",
						resize: function( event, ui ) {
				
								/* maxHeight &  minHeight */
								var orginalSize = ui.originalSize.height,
									size 		= ui.size.height,
									elems		= $(this).find( 'div.' + printItem ),
									maxSize 	= size + pageBody.height() + pageFooter.height();
							
								if ( maxSize >= page.height() ){ 
										pageHeader.resizable("option","maxHeight",size);
										//return;
									}//if
						
								pageBody.resizable("option","maxHeight",null);		
								pageFooter.resizable("option","maxHeight",null);	
				
								/*minHeight*/
								var maxTop = 0, div;
								
								if(elems.length > 0) {
								
									$.each(elems, function() {
										
												var top	= $(this).position().top;
												
												if ( top > maxTop  ){
														maxTop = top;
														div = $(this);
													}//if
											}); // each
											
									pageHeader.resizable("option","minHeight",maxTop + div.innerHeight());
								
								} // if
						
							}

					});
			 
		pageBody.resizable({
						containment: 'parent', 
						handles: "s,e",
						resize: function( event, ui ) {
							
								/*maxHeight*/
								var orginalSize = ui.originalSize.height,
									size 		= ui.size.height,
									elems		= $(this).find( 'div.' + printItem ),
									maxSize 	= size + pageHeader.height() + pageFooter.height();
										
								if ( maxSize >= page.height() ){ 
								
											pageBody.resizable("option","maxHeight",size);
											//return;
										}
									
								pageHeader.resizable("option","maxHeight",null);		
								pageFooter.resizable("option","maxHeight",null);
									
								/*minHeight*/
								var maxTop = 0, div;
								
								if(elems.length > 0 ){
									
										$.each(elems, function() {
	
													var top	= $(this).position().top;
													
													if ( top > maxTop  ){
															maxTop = top;
															div = $(this);
														}//if
												}); // each
												
										pageBody.resizable("option","minHeight",maxTop + div.innerHeight());
									
									} // if
							}
					
					});
			 
		pageFooter.resizable({
						containment: 'parent', 
						handles: "s,e",
						resize: function( event, ui ) {
							
								/*maxHeight*/
								var orginalSize = ui.originalSize.height,
									size 		= ui.size.height,
									elems		= $(this).find( 'div.' + printItem ),
									maxSize 	= size + pageBody.height() + pageHeader.height();
																		
								if ( maxSize >= page.height() ){ 
								
											pageFooter.resizable("option","maxHeight",size);
											//return;
										}
									
								pageHeader.resizable("option","maxHeight",null);		
								pageBody.resizable("option","maxHeight",null);	
								
								/*minHeight*/
								var maxTop = 0, div;
								
								if (elems.length > 0 ) {
								
										$.each(elems,  function() {
											
													var top	= $(this).position().top;
													
													if ( top > maxTop  ){
															maxTop = top;
															div = $(this);
														}//if
												}); // each
												
										pageFooter.resizable("option","minHeight",maxTop + div.innerHeight());	
								
									} //if
							
							}
					
					});	

		/* template functions */
	
		w.on('input', function(){
					
					var v = $(this).val();

					
					if ( !$.isNumeric(v) || v > 210 ) $(this).val(' ');
					
						var page = PrintPagesize(v);
							page.width();
							page.rW();
				
				}); // w on input
				
		h.on('input', function(){
				
					var v = $(this).val();
					
					if ( !$.isNumeric(v) || ( v > 290 )) $(this).val(' ');

						var page = PrintPagesize(null,v);
							page.height();
							page.rH();
					
				}); // h on input
			
		pd.on('input', function(){
				
					var v 	= $(this).val();
					var mm	= parseFloat( 3.779527559 );
					var padding = [] ;	
							
						var l = $.trim(v).split(' ');
						
						if ( l.length < 5 ){
						
								for(var i = 0; i < l.length ; i++) {
										if (!$.isNumeric(l[i]) || l[i] > 35 ) l[i] = 0;
										padding.push( l[i] * mm );
									} // for
										
								var c = padding.join('px ') +'px';	
								
								page.css('padding', c);
								$.extend(o.page[0].style, { padding : c });
															
							} // if

				}); // h on input
			
		t.on('change', function(){
								
				var v = $(this).find('option:selected').val();
				
				var type = [{
						 0 : {  width: '210',	height: '297' }, //a4
						 1 : {  width: '148',	height: '210' }, //a5
						 2 : {  width: '100',	height: '100' }  //special 
				}]; // data
					
					var width	= type[0][v].width;
					var height	= type[0][v].height;
					
					var _page = PrintPagesize(width, height);
								_page.width();
								_page.height();
								_page.rW();
								_page.rH();
			
				}); // t on change
			
		r.on('change', function(){
							
						var _w = h.val();		
						var _h = w.val();	
							
					var page = PrintPagesize(_w, _h);
							page.width();
							page.height();
							page.rW();
							page.rH();

				}); // r on change

		f.on('change', function(){
				
					var el		= $(this);
					var type 	= elementStyle.attr('type');
					
					if ( type === 'item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, {fontFamily : el.val()});
						
						} // if
						
					if ( type === 'table-item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.tables.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, {fontFamily : el.val()});
						
						} // if
						
					if ( !type ) {
						
							$.extend(o.page[0].style, {fontFamily : el.val()});
						
						} // if											

				}); // f on change
			
		s.on('change', function(){
							
					var el		= $(this);
					var type 	= elementStyle.attr('type');
					
					if ( type === 'item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, {fontSize : el.val()});
						
						} // if
						
					if ( type === 'table-item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.tables.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, {fontSize : el.val()});
						
						} // if
						
					if ( !type ) {
						
							$.extend(o.page[0].style, {fontSize : el.val()});
						
						} // if			
				
				}); // s on change
				
		b.on('click', function(){
				
					var el		= $(this);
					var type 	= elementStyle.attr('type');
					
					el.toggleClass(activeClass);
					var check = el.hasClass(activeClass);
					
					if ( type === 'item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, {fontWeight : check });
						
						} // if
						
					if ( type === 'table-item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.tables.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, {fontWeight : check });
						
						} // if
						
					if ( !type ) {
						
							$.extend(o.page[0].style, {fontWeight : check });
						
						} // if	
						
				}); // b on click
				
		i.on('click', function(){
				
					var el		= $(this);
					var type 	= elementStyle.attr('type');
					
					el.toggleClass(activeClass);
					var check = el.hasClass(activeClass);
					
					if ( type === 'item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, {fontStlye : check });
						
						} // if
						
					if ( type === 'table-item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.tables.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, {fontStlye : check });
						
						} // if
						
					if ( !type ) {
						
							$.extend(o.page[0].style, {fontStlye : check });
						
						} // if								
				
				}); // i on click
						
		u.on('click', function(){
				
					var el		= $(this);
					var type 	= elementStyle.attr('type');
					
					el.toggleClass(activeClass);
					var check = el.hasClass(activeClass);
					
					if ( type === 'item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, {textDecoration : check });
						
						} // if
						
					if ( type === 'table-item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.tables.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, {textDecoration : check });
						
						} // if
						
					if ( !type ) {
						
							$.extend(o.page[0].style, {textDecoration : check });
						
						} // if	
				
				}); // u on click
		
		aC.on('click', function(){
				
				var el		= $(this);
				var type 	= elementStyle.attr('type');
				
				
				$.each([ aL, aR, aJ],function(){$(this).removeClass(activeClass);});
				
				el.toggleClass(activeClass);
				var check = el.hasClass(activeClass);
				
				if ( type === 'item' ) {
					
						var control = elementStyle.attr('item');
						var data 	= $.grep(o.items,function (v){ return  v.item == control; });
						
						$.extend(data[0].style, { align : (check) ? 'center' : null });
					
					} // if
					
				if ( type === 'table-item' ) {
					
						var control = elementStyle.attr('item');
						var data 	= $.grep(o.tables.items,function (v){ return  v.item == control; });
						
						$.extend(data[0].style, { align : (check) ? 'center' : null });
					
					} // if
			
			}); // aC on click
				
		aL.on('click', function(){
				
					var el		= $(this);
					var type 	= elementStyle.attr('type');
					
					
					$.each([ aC, aR, aJ],function(){$(this).removeClass(activeClass);});
					
					el.toggleClass(activeClass);
					var check = el.hasClass(activeClass);
					
					if ( type === 'item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, { align : (check) ? 'left' : null });
						
						} // if
						
					if ( type === 'table-item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.tables.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, { align : (check) ? 'left' : null });
						
						} // if
				
				}); // aL on click	
				
		aR.on('click', function(){
				
					var el		= $(this);
					var type 	= elementStyle.attr('type');
					
					
					$.each([ aC, aL, aJ],function(){$(this).removeClass(activeClass);});
					
					el.toggleClass(activeClass);
					var check = el.hasClass(activeClass);
					
					if ( type === 'item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, { align : (check) ? 'right' : null });
						
						} // if
						
					if ( type === 'table-item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.tables.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, { align : (check) ? 'right' : null });
						
						} // if
				
				}); // aR on click	
		
		aJ.on('click', function(){
				
					var el		= $(this);
					var type 	= elementStyle.attr('type');
					
					
					$.each([ aC, aL, aR],function(){$(this).removeClass(activeClass);});
					
					el.toggleClass(activeClass);
					var check = el.hasClass(activeClass);
					
					if ( type === 'item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, { align : (check) ? 'justify' : null });
						
						} // if
						
					if ( type === 'table-item' ) {
						
							var control = elementStyle.attr('item');
							var data 	= $.grep(o.tables.items,function (v){ return  v.item == control; });
							
							$.extend(data[0].style, { align : (check) ? 'justify' : null });
						
						} // if
				
				}); // aJ on click			
		
		bg.on('change', function(){
				console.log($(this));
					var $el = $(this);
					var el	= this; 
					var type = ['image/jpeg','image/jpg','image/png'];
					
					var control = type.indexOf(el.files[0].type) ; 
					
						if (control >= 0) {
							
								 var reader = new FileReader();
			
									reader.onload = function (e) {
																				
										var style = {"background-image": "url('" + e.target.result + "')"};			
										page.css(style);
									};
									
									reader.readAsDataURL(el.files[0]);
							} // if control
					
				}); // bg on click	
			
		/*Object Parse*/		
				
		var width	= o.page[0].style.width ,
			height	= o.page[0].style.height ,
			rotate	= o.page[0].rotate ,
			type	= o.page[0].type ,
			padding	= o.page[0].style.padding, 
			fixHeader = o.page[0].fixHeader;
				
		var _page = PrintPagesize(width, height);
		
			_page.width();
			_page.height();
			_page.rW();
			_page.rH();
				
		t.find('option[value='+ type +']').prop('selected','selected');
		r.find('option[value='+ rotate +']').prop('selected','selected');
		
		hf.prop('checked',fixHeader);
		page.css('padding',padding);
		
		if ( o.items.length > 0) {
			
				$.each(o.page[0].divs, function(){
										
						page.find('#' + this.name ).css(this.style);
					
					});
		
				$.each(o.items, function(k, v) {
						//console.log (k, v)
						
						var id		= v.id,
							 item	= v.item,
							 name	= v.name,
							 style	= v.style,
							 data	= v.data,
							 div	= v.parentDiv;
						
						var css 	= { left : style.left, top : style.top,	height : style.height, width : style.width 	};
						
						$('<div>')
							.addClass([printItem, dragElClass].join(' '))
							.css(css)
							.attr({
									'id' : id,
									'item' : item,
									'type' : 'item',
									'onClick': 'itemActive(this,event)'
									})
							.append(function(){
							
								( !data ) ? $(this).append(name) : $('<textarea>').val(data).appendTo(this);
								$('<i>').addClass('icon-remove position-ne').attr('onClick','itemDelete(this,event)').appendTo(this);
							
							})
							.appendTo(page.find( '#' + div ))
							.resizable({containment: "parent"})
							.draggable({containment: "parent"});
					
					}); //each
					
			} // if 
			
		if ( o.tables.items.length > 0 ) {
			
				$.each(o.tables.style, function(k, v){
						//console.log (k,v);
						
						var style	= v;
						var css 	= { left : style.left, top : style.top,	height : style.height, width : style.width 	};
												
						$('<table>')
								.addClass(printItem)
								.css(css)
								.attr('data', 'table-list')
								.append(
									$('<thead>')
										.append(
											$('<tr>').append(function(){
												
												var tr = this;
												$.each(o.tables.items, function(ke, va){
														//console.log (ke, va);
														
														var id		= va.id,
															item	= va.item,
															name	= va.name,
															style	= va.style,
															pageSum = va.pageSum,
															 
															css	= { height : style.height, width : style.width},
															attr	= {'id' : id , item : item, 'onClick': 'itemActive(this,event)', 'type' : 'table-item' };
															
														$('<th>')
															.css(css)
															.attr(attr)
															.append(name,$('<i>').addClass('icon-remove position-ne').attr('onClick','itemDelete(this,event)'))
															.appendTo(tr)
															.resizable();
														
														lists.find('li#' + id ).children('input[type="checkbox"]').prop('checked',true);
															
														if ( pageSum ) {
														
																var attr = { item  : va.div.item }, 
																	 css = { left : va.div.left , top:  va.div.top, width : va.div.width, height : va.div.height};
																				 
																$('<div>')
																	.addClass(dragElClass)
																	.css(css)
																	.attr(attr)
																	.append(
																		
																			$('<input>').attr('name','sumName').val( va.div.text ),
																			$('<span>').addClass('pull-right').append('Number')
																		
																		)
																	.appendTo(pageBody)
																	.resizable({containment: "parent"})
																	.draggable({containment: "parent"});
														
														
														}
															
															
													}); // each
										})
										),								
										 $('<tbody>')
											.append(function() {
		
													for (var i = 0 ; i < o.tables.rowCount; i++) {
													
														$('<tr>')
															.append(function(){
															
																var _tr = this;
		
																	for ( var j = 0; j < o.tables.items.length; j++ ) {
											
																		 $('<td>').append(' ').appendTo(_tr);
																		
																		}// for j
		
																})
															.appendTo(this);
												
														}// for i
									
												})
									  )
								.appendTo(pageBody)
								.resizable({containment: "parent"})
								.draggable({containment: "parent"});
					
					});
			
			} // if

		var clickFunction = 'savePrint()';
			
		modalFooter.find('input#actionButton').attr({onClick : clickFunction});
	
	
	}; // printElement	
	
var PrintPagesize = function(w, h) {
	
		var _w = w || 0, // width
			_h = h || 0, // height
			
			modal		= $('*').find('#printPanel'),
			pageStyle	= modal.find('#pageStyle'),
			page		= modal.find('#page'),
			_rW			= modal.find('#rullerTrick-W'),
			_rH			= modal.find('#rullerTrick-H'),						
			rate 		= parseFloat( 1 ),
			mm 			= parseFloat( 3.779527559 ),
		
			t	= pageStyle.find('select#type'),
			r	= pageStyle.find('select#rotate'),
			w	= pageStyle.find('input#width'),
			h	= pageStyle.find('input#height');

		var width = function () {
			
				var m2p = _w * mm / rate;
				
				w.val( _w );
				page.width( m2p );
				
			}; // width;
			
		var height = function () {
			
			var m2p = _h * mm / rate;
			
				h.val( _h );
				page.height( m2p );
			
			
			}; // height
			
		var rW = function () {
			
				var cm = Math.round( _w / 10 / rate ); 
											
				_rW.empty();
				
				for ( var i = 0 ; i < cm ; i++) {
					
						var div = '<div class="rullerTick-W"><span class="rullerNum">'+ i +'</span> <div class="rullerTickHalf-W"></div></div>';
					
						_rW.append(div);
					
					} //for
			
			}; // rW
			
		var rH = function () {
			
				var cm = Math.round( _h / 10 / rate ); 
											
				_rH.empty();
				
				for ( var i = 0 ; i < cm ; i++) {
					
						var div = '<div class="rullerTick-H"><span class="rullerNum">'+ i +'</span> <div class="rullerTickHalf-H"></div></div>';
					
						_rH.append(div);
					
					} //for
			
			}; // rH
			
		return { width : width, height : height, rW : rW, rH : rH };
	
	}; // PrintPagesize
	
var savePrint = function () {
	
		var modalId			= 'printPanel',
			pageId			= 'page',
			printItem		= 'printItem',
			modal			= $( '#' + modalId ),
			page			= modal.find( '#' + pageId ),
			printEl			= page.find( 'div.' + printItem ),
			tableList		= page.find('table[data="table-list"]'),
			elementStyle	= page.find('#elemetStyle'),
			pageHeader		= page.find('#pageHeader'),
			pageBody		= page.find('#pageBody'),
			pageFooter		= page.find('#pageFooter'),
			
			t	= modal.find('select#type option:selected').val(),
			r	= modal.find('select#rotate option:selected').val(),
			w	= modal.find('input#width').val(),
			h	= modal.find('input#height').val(),
			o 	= printObject,
					//Emin 
				 pName	= modal.find('input#printName').val(), // PrintName
				 cName	= modal.find('input#cName').val(), // ControllerName
				 cIdP	= modal.find('input#cIdPrint').val(), // CompanyId
				 printActionId = modal.find('input#printActionId').val(); // CompanyId
		
		$.each(o.page, function(k, v){
				//console.log (v);
			
				$.extend( v, { type : t, rotate : r, name : pName, cName : cName, cId : cIdP, printActionId :printActionId} );
				$.extend( v.style, {width : w, height : h } );	
			
			}); // each 
			
		$.each( [ pageHeader, pageBody, pageFooter ], function(){

				$.extend( o.page[0].divs[ $(this).attr('id')], { name :  $(this).attr('id'), style : { height : $(this).height()} } );
			 
			}); // each 
		
		$.each(printEl, function(k, v){
			
				var el 	= $(v),
					 i	= el.attr('id'),
					 it	= el.attr('item'),
					 p	= el.parent('div'),
					 pI	= p.attr('id'),
					 x	= el.offset().left - p.offset().left,
					 y	= el.offset().top -  p.offset().top,
					 
					 h	= el.height(),
					 w	= el.width();

				var control = $.grep(o.items,function (v){ return  v.id == i; });
			
				$.extend( control[0], { parentDiv : pI  } );
				$.extend( control[0].style, { left: x, top : y, height : h, width : w } );
				
				if (it.indexOf('personal') >= 0 ){ 
					
						var inputs = 'textarea, input';
						
						$.extend(control[0],{ data : el.find( inputs ).val()}); 
					
					} // if			

			}); // each 
	
		$.each(tableList, function(k, v){
				//console.log (k, v);
			 
			var td = tableList.find('thead tr:first > th');
			  
			var el 	= $(v),
				p	= el.parent('div'),
				x	= el.offset().left - p.offset().left,
				y	= el.offset().top - p.offset().top,
				h	= el.height(),
				w	= el.width(); 
			  
			$.extend( o.tables.style[0], { left: x, top : y, height : h, width : w } );		
			
			$.each(td, function(ke, va){
					//console.log(ke, va);
						
						var el 	= $(va),
							i	= el.attr('item'),
							h	= el.height(),
							w	= el.width();
						
						var control = $.grep(o.tables.items,function (v){ return  v.item == i; });
											
						$.extend( control[0].style, { height : h, width : w } );
						
						if( control[0].pageSum ) {
								
								var sumDiv = pageBody.find('div[item="' + i + '-sum"]');
								
									$.extend(control[0], { div : { left : sumDiv.offset().left - p.offset().left , top : sumDiv.offset().top - p.offset().top , width :sumDiv.width() , height : sumDiv.height() , item : i + '-sum' , text : sumDiv.find('input').val()  } })
								
							} // if 
						
				}); // each
			
			}); //each	
			
		//console.log (  printObject );
		//console.log ( JSON.stringify( printObject) );
		//$.print(page);	
		//return false;
		
		 $.ajax({
			  url: '/WMO/print.cfc?method=addPrintJson&printJson=' + JSON.stringify(printObject)+ '',
			  error: function(r) {
					console.log (r);
					location.reload();
			  },
			  success: function(data) {
				//console.log(data);
				 location.reload();
			  }
		   });
		   
	}; // savePrint
	
var itemDelete = function (el, event) {
		//console.log (el);
	
	"use strict";
		
		event.stopPropagation();
		
		var t = $(el).parent('div, th').attr('type');
		var o = printObject;
	
		if ( t === 'item' ){
		
				var el	= $(el).parent('div');
				var i	= el.attr('item');
	
				$.each(o.items, function (k,v){	if (v.item == i ){ o.items.splice(k,1);	el.remove(); return false; } });//each
					
			} // if

		if(t === 'table-item' ){
		
				var el	= $(el).parent('th');
				var i	= el.attr('item');
				var table = el.parents('table');
				
				$.each(o.tables.items, function (k,v){
					if (v.item == i ){
							o.tables.items.splice(k,1);
							table.find('tr').find('td:first').remove();						
							el.remove();						
								if (o.tables.items.length == 0){ o.tables.style.splice(0,1); o.tables.rowCount = null; table.remove(); }
							return false;
						} // if
					});//each
					
			} // if
	
	}; // itemDelete	
	
var itemActive = function (el, event) {
		//console.log (el);

	"use strict";	
		
		event.stopPropagation();
		
		var modalId			= 'printPanel',
			activeClass		= 'active',
			modalPanel 		= $('*').find('div#' + modalId ),
			modalBody		= modalPanel.find('.modal-body'),
			page 			= modalBody.find('#page'),
			elementStyle	= modalPanel.find('#elemetStyle'),
			columnSum		= elementStyle.find('#columnSum'),
			o				= printObject,
			data, style,
			
			f	= elementStyle.find('select#font-family'),
			s	= elementStyle.find('select#font-size'),
			
			b	= elementStyle.find('button#font-bold'),
			i	= elementStyle.find('button#font-italic'),
			u	= elementStyle.find('button#font-underline'),
			
			aJ	= elementStyle.find('button#align-justify'),
			aR	= elementStyle.find('button#align-right'),
			aC	= elementStyle.find('button#align-center'),
			aL	= elementStyle.find('button#align-left'),
			
			n 	= elementStyle.find('span#name'),
			cS	= elementStyle.find('#columnSum input[type="checkbox"]');
		
		page.find('.' + activeClass).removeClass(activeClass);
			
		var t = $(el).attr('type');
	
			if  ( t === 'item' ) {
				
					var el		= $(el),
						 elItem	= el.attr('item'),
						 elText	= el.text();
					
						data	= $.grep(o.items, function(v){ return v.item == elItem; });
						style 	= data[0].style;						
	
					n.empty().text(elText);	
					elementStyle.attr({'item' : elItem , 'type' : 'item'});			
					el.addClass(activeClass);
					columnSum.hide();
				
				
				} // if
		
			if  ( t === 'table-item' ) {
				
					var el		= $(el),
						 elItem	= el.attr('item'),
						 elText	= el.text();
					
						data 	= $.grep(o.tables.items, function(v){return v.item == elItem; });
						style	= data[0].style;						
	
					n.empty().text(elText);	
					elementStyle.attr({'item':elItem , 'type' : 'table-item'});		
					el.addClass(activeClass);
					columnSum.show();
				
				} // if
	
			if  ( !t ) {
				
					n.empty().text('Şablon'); // dile eklenecek
					elementStyle.attr({'item':null , 'type' : null});
							
					data  = $.grep(o.page, function(v){ return v; });	
					style = data[0].style;
				
				} // if
			
		var fFamily	= style.fontFamily,
			fSize	= style.fontSize,
			fBold	= style.fontWeight,
			fItalic = style.fontStlye,
			fUnderLine = style.textDecoration,
			aling = style.align,
			pageSum = data[0].pageSum;
						
			f.val(fFamily);
			s.val(fSize);
			
			b.removeClass(activeClass);
			i.removeClass(activeClass);
			u.removeClass(activeClass);
			
			if( fBold ) b.addClass(activeClass);
			if( fItalic ) i.addClass(activeClass);
			if( fUnderLine ) u.addClass(activeClass);
		
		cS.prop('checked',pageSum);
			
		$.each([ aC, aL, aR, aJ ],function(){$(this).removeClass(activeClass);});
		switch ( aling ){case 'left' : aL.addClass(activeClass); break; case 'right' : aR.addClass(activeClass);break; case 'center' : aC.addClass(activeClass);break; case 'justify' : aJ.addClass(activeClass);break; default :return false;};

	
	}; // itemActive

var createTemplate = function (settings) {

	"use strict";

	//debugger;
		
		var modalId			= 'printPage',
			modalPanel 		= $('*').find('div#' + modalId ),
			modalHeader		= modalPanel.find('.modal-header'),
			modalBody		= modalPanel.find('.modal-body'),
			modalFooter		= modalPanel.find('.modal-footer'),
			templateBody	= modalBody.find('div#templateBody'),
			
			fonts = [{
						 0 : null,
						 1 : null,
						 2 : 'Times New Roman, Times, serif;',
						 3 : 'Tahoma, Verdana, Segoe, sans-serif;', 
				}], // fonts
			 	fontSize = [ { 0 : '11px', 1 : '1px',2 : '2px',3 : '3px', 4 : '4px',5 : '5px', 6 : '6px',7 : '7px',8 : '8px',9 : '9px', 10 : '10px', 11 : '11px' } ]; // fontSize
		
		
		modalHeader.find('.modal-title').text('Print');
		modalFooter.find('input#printBook').attr('onClick' ,'printPage("bookSubpage")');
		templateBody.empty();
					
		if ( settings.jSon ) {
			
				var json = $.parseJSON(settings.jSon);
		
					var w	= json.page[0].style.width,
						h	= json.page[0].style.height,
						pd  = json.page[0].style.padding,
						dv	= json.page[0].divs,
						fh	= json.page[0].fixHeader,
						rC	= json.tables.rowCount || 1,
						lC	= ( json.tables.rowCount ) ? settings.rowDataList.ROWCOUNT : 1,
						pC	= Math.ceil ( lC / rC ),
						mm 	= parseFloat( 3.779527559 );
						
						$('<div>')
							.attr('id','book')
							.appendTo(templateBody);
					
						var sR	= 0, fR	= rC;
						
						for ( var k = 0 ; k < pC ; k ++ ) {
							
								var css = { "width": w * mm, "height" : h * mm, "padding" : pd};
					
								$('<div>')
									.css(css)
									.attr('id','bookSubpage')
									.appendTo(modalBody.find('div#book'));
									
								var subpage = modalBody.find('div#bookSubpage').eq(k);
										
								$.each(dv, function(){
									
									if ( !fh && k > 0 ){

											if( this.name === 'pageHeader'){
													
													$('<div>').attr('id',this.name).hide().appendTo(subpage);
				
												} // if
												
											if( this.name === 'pageBody'){
												
												$('<div>').attr('id',this.name).css({height : this.style.height + dv.pageHeader.style.height }).appendTo(subpage);
												
												
												} //if
											
											if( this.name === 'pageFooter'){
												
												 $('<div>').attr('id',this.name).css(this.style).appendTo(subpage); 
												
												}// if
									
										}else{
											
											$('<div>')
												.attr('id',this.name)
												.css(this.style)
												.appendTo(subpage);
											
											} // if
				
									}); // each
							
								$.each(json.items, function(k, v) {
										//console.log (k, v)
										
										var id		= v.id,
											item	= v.item,
											style	= v.style,
											data	= v.data,
											div		= v.parentDiv;
											
										var appendDiv	= subpage.find('#' + div );	
										var css 		= { "margin-left" : style.left, "margin-top" : style.top,"height" : style.height, "width" : style.width,"text-align" : style.align,"font-familty" : fonts[0][style.fontFamily],"font-Size"	: fontSize[0][style.fontSize] };
										
										if ( !data ) { $.each(settings.bodyDataList.DATA, function(v,k){ if (v == item){ data = k ; return false; } }); }
										
										$('<div>')
											.attr('item', item)
											.css(css)					
											.append(data)
											.appendTo(appendDiv);
					
									}); // each
																			
								$.each(json.tables.style, function(k, v){
											//console.log (k,v);
											
											var style	= v,
												 css 	= { "margin-left" : style.left, "margin-top" : style.top,	height : style.height, width : style.width, padding:0};
											
											$('<div>')
												.css(css)
												.append(function(){
																	
														$('<table>')
															.append(
																$('<thead>')
																	.append(
																		$('<tr>').append(function(){
																		
																			var tr = this;
																			
																			$.each(json.tables.items, function(ke, va){
																					//console.log (ke, va);
																					
																					var id		= va.id,
																						item	= va.item,
																						name	= va.name,
																						style	= va.style;	
																					
																					var css 	= { "height" : style.height, "width" : style.width,"text-align" : style.align,"font-familty" : fonts[0][style.fontFamily],"font-Size"	: fontSize[0][style.fontSize]},
																						 attr	= { id : id , item : item }; 
																					
																					$('<th>')
																						.css(css)
																						.attr(attr)
																						.append(name)
																						.appendTo(tr);
																				
																				}); // each
																	
																	})
																	),
																	 $('<tbody>')
																		.append(function() {
																		  
																			for (var i = sR ; i < fR; i++ ){
																			
																					$('<tr>')
																						.append(function(){
																							
																								var tr = this;
																								
																								$.each(json.tables.items, function(ke, va){
																										//console.log (ke, va);
																										
																										var id		= va.id,
																											 item	= va.item;
																									
																										var v = $.map(settings.rowDataList.DATA,function(v,k){if ( k == item) return v;}),
																											 c = {"text-align" : va.style.align }
																									
																										$('<td>')
																											.css(c)
																											.append(v[i])	
																											.appendTo(tr);
																									
																									}); // each
																							})
																						.appendTo(this)	;
																				
																				} // for
																		})
																  )
															.appendTo(this);
													})
												.appendTo(subpage.find('#pageBody'));
	
										}); // each
										
								var sums = $.grep( json.tables.items, function(v){ return v.pageSum;});

								$.each(sums,function(k,v){
								
												var css = { "margin-left" : v.div.left, "margin-top" : v.div.top, width : v.div.width , height: v.div.height}
												
												
												$('<div>')
													.attr('item', v.div.item)
													.css(css)
													.append(v.div.text)
													.appendTo(subpage.find('#pageBody'));

											}); // each
						
								sR = fR ; 
								fR = sR + rC
								
								subpage.addClass('pageBreak');
																		  						
							} // for	
				
			} // if 		

	
	}; // createTemplate	
	
var printPage = function (el){
	
	"use strict";
	
		var modalId		= 'printPage';
		var modalPanel 	= $('*').find('div#' + modalId );
		var modalBody	= modalPanel.find('.modal-body');

		var page = modalBody.find('div#'+el);
	
		$.print(page);	
	
	}; // printPage
	
var tableSettings = function ( hdlr, el ){
	
	"use strict";
	
		var modalId			= 'printPanel',
			printItem	 	= 'printItem',
			dragElClass		= 'dragEl',
			modalPanel 		= $('*').find('div#' + modalId ),
			modalBody		= modalPanel.find('.modal-body'),
			elementStyle	= modalPanel.find('#elemetStyle'),
			page 			= modalBody.find('#page'),
			pageHeader		= modalBody.find('#pageHeader'),
			pageBody		= modalBody.find('#pageBody'),
			pageFooter		= modalBody.find('#pageFooter'),
			tableList		= page.find('table[data="table-list"]'),
			o				= printObject;
	
		var handler = {
			
				addRow : function (){
					
					var newTr	 = tableList.find('tbody > tr:first').clone();
					var rowCount = o.tables.rowCount;
					
					if (rowCount) {
								o.tables.rowCount = rowCount + 1; 
								tableList.find('tbody').append(newTr);	
						}// if
					
					},
				
				delRow : function (){
					
					var rowCount = o.tables.rowCount;
					
					if (rowCount > 1 ) {
								o.tables.rowCount = rowCount - 1; 
								tableList.find('tbody > tr:last').remove();
						}// if					
					
					},
					
				columnVisb : function ( el ){
					
						if (tableList.length === 0 ) return false;
					
						var li = $(el).parent('li'),
							 re = li.attr('response');
						
						
						if ($(el).get(0).checked) {
								var d	 = re.split('$'),
									attr = {'id' : 'table-item-' + d[0] , item : d[0], response : re, 'type' : 'table-item','onClick': 'itemActive(this,event)' };
								
								$('<th>')
									.attr(attr)
									.append(d[1],$('<i>').addClass('icon-remove position-ne').attr('onClick','itemDelete(this,event)'))
									.appendTo(tableList.find('thead > tr:first'))
									.resizable();
								
								var item = { item : d[0], id : 'table-item-' + d[0] , name : d[1], response : re, style : { height : 0, width : 0, fontFamily: 0, fontSize:0, textDecoration : false, fontStlye : false, fontWeight : false, align : null } };
							
								o.tables.items.push(item);
								tableList.find('tbody > tr ').append( $('<td>').append(' '))
					
							}else {

								var i	= li.attr('item');				
								$.each(o.tables.items, function (k,v){
										if (v.item == i ){
											o.tables.items.splice(k,1);
											tableList.find('thead > tr:first th#'+ v.id ).remove();
											
												$.each(tableList.find('tbody > tr '),function(){ $(this).find('td:first').remove(); })
											
											if (o.tables.items.length == 0){ o.tables.style.splice(0,1); o.tables.rowCount = null; tableList.remove(); }
											return false;
										} // if
									});//each	
						
								}//if
					},
					
				columnSum : function( ){
						
						var e = elementStyle.find('input[type="checkbox"]'), 
							i = elementStyle.attr('item'),
							data = $.grep(o.tables.items, function(v){ return v.item == i; });
							
						$.extend(data[0],{pageSum : e.prop('checked')});
			 
			 			
						if ( !e.prop('checked') ){
							
								pageBody.find('div[item="' + i + '-sum"]').remove();
														
							} else {
															
								var attr = { item  : i + '-sum' }, 
									 css = { top : pageBody.height() - 50 , left :  '50%'};
										 		 
								$('<div>')
									.addClass(dragElClass)
									.css(css)
									.attr(attr)
									.append(
										
											$('<input>').attr('name','sumName'),
											$('<span>').addClass('pull-right').append('Number')
										
										)
									.appendTo(pageBody)
									.resizable({containment: "parent"})
									.draggable({containment: "parent"});
								
								} //if 
			 
					}	
			
			}; // handler
	
		handler[hdlr].apply(this, [el]);
	
	}; // tableSettings	
	
var headerFixed = function (el) {
	
		var o = printObject;
		var s = $(el).is(':checked');
		
		$.extend( o.page[0], { fixHeader : s } );
	
	} // headerFixed

// Emin : Selectbox'tan secilen sablon bulunup ekranda gösterilir
var getPrint = function(compId,cName,cPrintCfcName,pageActionId,printActionId,type){

	var printJson,printBodyList,printBodyDataList,printRowList,printRowDataList = null;
//	console.log(arguments);
	$.ajax({url: '/WMO/print.cfc?method=getPrintJson&companyId='+compId+'&controllerName='+cName+'&actionId='+printActionId, async:false,success: function(data) { if (data.length > 10) { printJson = data } }}); // ajax

	if(cPrintCfcName){
				
		$("#printActionId").val(printActionId);
		
		var printBodyList
		$.ajax({ url: '/cfc/'+cPrintCfcName+'.cfc?method=printBodyColumns', async:false, success: function(data) {if (data.length < 10) {printBodyList = null}else {printBodyList = data } }}); // ajax
		var printBodyDataList
		$.ajax({ url: '/cfc/'+cPrintCfcName+'.cfc?method=printBodyData&identityNumber='+pageActionId, async:false, success: function(data) {if (data.length < 10) {printBodyDataList = null}else {printBodyDataList = data } }}); // ajax
		var printRowList
		$.ajax({ url: '/cfc/'+cPrintCfcName+'.cfc?method=printRowColumns', async:false, success: function(data) {if (data.length < 10) {printRowList = null}else {printRowList = data } }}); // ajax
		var printRowDataList
		$.ajax({ url: '/cfc/'+cPrintCfcName+'.cfc?method=printRowData&identityNumber='+pageActionId, async:false, success: function(data) {if (data.length < 10) {printRowDataList = null}else {printRowDataList = data } }}); // ajax
		
		if(type == 0){
			var printSettings = {
				
				bodyList : printBodyList.substr(printBodyList,printBodyList.length-1),
				rowsList : printRowList.substr(printRowList,printRowList.length-1),
				jSon 	: printJson
			};	
			printElement(printSettings);
			
		}else{
			var printSettings = {
				jSon 	: printJson,
				bodyDataList :$.parseJSON(printBodyDataList),
				rowDataList :$.parseJSON(printRowDataList)
			};	
			createTemplate(printSettings);
		} 
		
		
	}else {
		
		var printSettings = {
			
			bodyList : null,
			rowsList : null,
			jSon 	: printJson,
			bodyDataList : null,
			rowDataList : null
		};
		printElement(printSettings);
		
	}
	
} ; //	getPrint 
	
	