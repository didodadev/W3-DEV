// global


/**

	validate			: 
	validateMessage		: 
	
	// Oluşturan : Emrah Kumru
	
**/

var validate = function (){
	
	"use strict";
	
		var columnName		= 'column',
			handle	        = 'form-group',
			required		= 'required',
			elSel			= 'input:visible, select:visible, textarea:visible, button:visible, select.multiSelect',
			elements 		= $('div[type="' + columnName + '"]').find('.' + handle +':visible ' + elSel),
			status	= true;

		var set = function (){
			
				var functions = {
					
						type : function (arg, el){
							
								var element = $(el);
							
								if ( arg.toLowerCase() === 'number' ){
									
										if ( !$.isNumeric(val) ){
												
												var val 	= element.val(),
													newVal	= val.replace( /[-._$@!%#'"^&*();/\\/|<> :?=öüğçışİ+,A-Z]/ig, '');
						
													element.val(newVal);
												
												}//if			
									
									} // if 
							
							},
							
						format : function (arg, el){
							
								var element = $(el);

								if ( arg.toLowerCase() === 'mail' ){
											
										var val 	= String( element.val() ),
											control	= new RegExp(/[-._+,0-9a-zA-Z]+([0-9a-zA-Z,-._+])*[0-9a-zA-Z,-._+]+@[0-9a-zA-Z]+([-.,0-9a-zA-Z]+)*([0-9a-zA-Z,.])[a-zA-Z]{2,6}/ig);

										if(!control.test(val)){
												validateMessage('notValid', element);
												status = false;
											
											}else{
													validateMessage('valid', element);	
												} // if
									
									} // if 
									
								if ( arg.toLowerCase() === 'date' ){
										
										var val		= String( element.val()),
											control	= new RegExp(/(0?[1-9]|[12][0-9]|3[01])[\/](0?[1-9]|1[012])[\/]\d{4}/ig);

										if(!control.test(val)){
											
												validateMessage('notValid', element);
												status = false;
											
											}else{
													validateMessage('valid', element);	
													
												} // if
										
										
											
											
									
									
									} // if 
							
							},	
					
						max : function (arg, el){
								//console.log(arguments)
								var element = $(el);							
							
								if ( element.data('type') === 'number' ) {
									
										var val = parseInt( element.val());
	
										if ( val > arg ) {
											
												element.val(arg);
											
											} // if
						
									} // if

							},
							
						min : function (arg, el){
								
								var element = $(el);							
	
								if (element.data('type') === 'number') {
									
										var val = parseInt( element.val());
	
										if ( val < arg ) {
											
												element.val(arg);
											
											} // if
										
									} // if
						
							},	
					
						len : function (arg, el){
								//console.log(arguments)
								
								var element = $(el);	

								var val = parseInt( element.val().length );
								
								if ( val > arg ) {
									
										element.val( element.val().substring(0, arg) );
									
									} // if
							
							},
							
						regex : function (){
							
							
							},	
						
					}; // functions
			
				elements.on('keyup change',function(){
					
						var element = $(this),
							data	= element.data();
					
						$.each(data, function(key,val){

								if (functions[key]) functions[key].apply(this ,[val, element]);
						
							}); // each
						
					}); // keyup

			
			};

		var check = function(){
				$.each(elements.filter('['+ required +']'), function(){

						var tagName = $(this).prop('tagName').toLowerCase(),
							data	= $(this).data(),
							val;
							
							if($(this).attr('class') == 'multiSelect')
								tagName = 'multiSelect';

						switch ( tagName ){
								case 'input': val = $(this).val(); break;
								case 'textarea' : val = $(this).val(); break;
								case 'select' :  val = $(this).find('option:selected').val(); break;
								case 'multiSelect' : val = $(this).val(); break;
							}

						if($.isArray(val))
							val = val.toString();
							
						if(val != null) // Bos multiselect null donduruyor.
							val  =  val.trim();
						else
							val = '';
						
						// value control
						if ( val === '' || val === null || val === 'undefined' || val === ' '){
												
								status = false;
								validateMessage( 'notValid', $(this));
						
							}else{
								
									var hidden	= $(this).parents('div.' + handle).find('input:hidden'),
										check	= false;
										
									if ( tagName !== 'select' ){
										
											$.each(hidden,function(){
													
													var val = $(this).val().trim();
													
													if (val != '' || val.length != 0 ){
				
															check = true;
															return false;
														
														} // if
															
												}); // each
										
										}else {
											
											check = true;
											
											} //if
									
									if ( check || hidden.length == 0 ){
													
											validateMessage( 'valid', $(this));
		
										}else {	
												status = false;
												validateMessage( 'notValid', $(this));
											
											}//if
							
								}// if
					
					}); // each
		
				if( status ) { return true; }else{ return false; }
			
			};

		return { set : set, check : check};
	
	}; // validate

var validateMessage = function( handler, el, msgIndex ){
	
	"use strict";
		
		var notValidClass	= 'border-red-haze',
			fontNotValid	= 'font-red-haze',
			validClass		= 'border-green-jungle', 
			validContent	= 'validContent';
			
		
		var messages = {
			
				max : 'Max. değer',
				min : 'Max. min değer',
				type : 'Geçersiz tip',
				regex : '',
				len : '',
				format : ''
			
			};	
			
	
		var functions = {
			
				notValid : function (el, msgIndex){
					var element 	= $(el),
						data		= element.data(),
						messages	= (data.msg) ? data.msg.split('|') : [],
						msgIndex	= (msgIndex) ? msgIndex : 0,
						divControl,divAfter;
					
					if(messages.length == 0)
						messages[0] = element.parents('.form-group').find('label').text();	

					if($(el).attr('class') == 'multiSelect')
						element = $(el).closest('div').find('button');
					
					element.addClass(notValidClass);
	
					var divControl = element.parent('div.input-group');
					
					( divControl.length != 0  ) ? divAfter = divControl :  divAfter = element;
					
						
						var required_item = $('<li>').addClass( [ 'required' ,validContent ].join(' ')).html('<i class="fa fa-terminal"></i> Eksik Veri : '+messages[msgIndex]);
						$('.ui-cfmodal__alert .required_list').append(required_item);	
						
	
						$('.ui-cfmodal__alert').fadeIn();
						$('#warning_modal').fadeOut();
					},
					
				valid : function (el){
						var element 	= $(el),
							data		= element.data(),
							formGroup 	= element.parents('div.form-group'),
							divControl,divAfter;
							
					var divControl = element.parent('div.input-group');
					
					( divControl.length != 0  ) ? divAfter = divControl :  divAfter = element;
							
					if($(el).attr('class') == 'multiSelect')
						element = $(el).closest('div').find('button');
					
						element.removeClass(notValidClass);
						element.addClass(validClass);
						//console.log(formGroup);
						divAfter.next('span.'+ validContent ).remove();
						
					}	
			
			}; //functions

		functions[handler].apply(this, [el, msgIndex]);
	
	}; // validateMessage	
