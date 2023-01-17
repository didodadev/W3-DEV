$(function(){

	var form = $("form[type=formControl]");
	var validate = true;

	$.install = {

		formControl : function(){

			form.submit(function(){
				
				validate = true;

				$(this).find(":input[required]").each(function(){

					var inputType = $(this).attr("type");
					
					
					if(inputType == "text" || inputType == "password" || inputType == "mail" || inputType == "tel" || inputType == "url"){
						
						if($.trim($(this).val()) == ''){
							
							$(this).css({"border-color":"red"});
							alert($(this).attr("message"));
							validate = false;

						}else{
							if(inputType == "password"){
								if(typeof passwordControl != "undefined"){
									validate = passwordControl();
									console.log(validate);
								}
							}
						} 
						
					}else if(inputType == "file"){
						
						var file = $(this).val().split('\\').pop();
						if(!file){
							alert($(this).attr("message"));
							validate = false;
						} 
		
					}else if(inputType == "checkbox" || inputType == "radio"){
		
						if(!$(this).is(":checked")){
							
							$(this).css({"border-color":"red"});
							alert($(this).attr("message"));
							validate = false;
						
						} 
		
					}
		
				});
/*
				$(this).find(":select[required]").each(function(){
			
					message = $(this).attr("message");
					if($.trim($(this).val()) == '' || $.trim($(this).val()) == 0) validate = false;
		
				});
*/
				return validate;

			});

		},
		formLoading : function(){

			form.submit(function(){
	
				if(validate){
					if(form.attr("step")){
						var stepNumber = parseInt(form.attr("step")) + 1;
						$(".step" + form.attr("step")).removeClass("stepactive");
						$(".step" + stepNumber + "").addClass("stepactive");
					}
					var submitButton = $(this).find("input[type=submit]");
					submitButton.prop("disabled",true).before('<span class="loading"><img src="html/files/images/loader.gif" width="40" height="40"></span>');
				}

			});

		}

	}

});