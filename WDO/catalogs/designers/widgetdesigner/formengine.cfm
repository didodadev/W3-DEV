<script>
	$("#wrk_submit_button").attr('onclick','return (confirm("Kaydetmek İstediğinizden Emin Misiniz?"))');
    $(function(){
	
	var solutionid =  $("input#solutionid").val();
	var familyid = $("input#familyid").val();
	var moduleno = $("input#moduleno").val();
	<cfif isdefined("widget_query")>
		loadFamilies(solutionid,'familyid','moduleno',familyid);
		loadModules(familyid,'moduleno',moduleno);
	</cfif>

	$("#codebox").hide();
	if ( $("input[name='tool']").val() == 'code' ) {
		$("#codebox").show();
	}


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
                if(validate) {
                    var chckd;
						chckd = $("select[name=eventType]").val();
						if(chckd == ""){
                                alert("Lütfen Event Typleri Seçiniz!");
                                return false;
                            }
					/*
                    if( $("select#tool").val() == "nocode" )
                    {
                        chckd = $("div.evnt input[type=checkbox]:checked").toArray().map(function(elm) { return $(elm).val(); }).join(',');
                            if(chckd == ""){
                                alert("Lütfen Event Typleri Seçiniz!");
                                return false;
                            }

                    }
                    else if( $("select#tool").val() == "code" ){
                        chckd = $("select[name=eventType]").val();
                    }*/

                    //isimlerini alalım
                    $("#solution").val( $("#solutionid option:selected").text() );
                    $("#family").val( $("#familyid option:selected").text() );
                    $("#module").val( $("#moduleno option:selected").text() );
                    $("#description").val(CKEDITOR.instances['description'].getData());
                    
                    $.ajax({
                        type:'POST',
                        url: '<cfoutput>#request.self#?fuseaction=dev.widget&mode=save&isAjax=1</cfoutput>',
                        data: $(form).serialize() + "&events="+chckd+"&stage=0",
						success:function(response){
							if(response != -1) location.href = '<cfoutput>#request.self#?fuseaction=dev.widget&event=add&id=</cfoutput>' + response+'&woid=<cfoutput><cfif isdefined("attributes.woid") and len(attributes.woid)>#attributes.woid#</cfif></cfoutput>';
							else alert("Bir hata oluştu");
						}
                	});
                return false;
				}
			});
		}
	}
    $.install.formControl();
});

function loadTool(val){
      //  $("div.hidetool").hide();
		$("input[name=file_path]").removeAttr('required message');
		$("input[name='file_path']").hide();
		$("select[name=eventType]").removeAttr('required message');
		$("#codebox").hide();
	//	$("#"+val).show("fast");
		if(val == "code") {
			$("input[name=file_path]").attr({"required":true,"message":'Dosya yolunu giriniz'});
			$("select[name=eventType]").attr({"required":true,"message":'Event typeni seçiniz'});
			$("input[name='file_path']").show();
			$("#codebox").show();
		}

	}
	
	function loadFamilies(solutionId,target,related,selected)
{
	$('#'+related+" option[value!='']").remove();
	$.ajax({
		  url: '/WMO/GeneralFunctions.cfc?method=getFamily&dsn=<cfoutput>#dsn#</Cfoutput>&solutionId=' + solutionId,
		  success: function(data) {
			if(data)
			{
				$('#'+target+" option[value!='']").remove();
				data = $.parseJSON( data );
				for(i=0;i<data.DATA.length;i++)
				{
					var option = $('<option/>');
					if(selected && selected == data.DATA[i][0])
						option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
					else
						option.attr({ 'value': data.DATA[i][0] }).text(data.DATA[i][1]);
					$('#'+target).append(option);
				}
			}
		  }
	   });
}
function loadModules(familyId,target,selected)
{
	$.ajax({
		  url: '/WMO/GeneralFunctions.cfc?method=getModule&dsn=<cfoutput>#dsn#</Cfoutput>&familyId=' + familyId,
		  success: function(data) {
			if(data)
			{
				$('#'+target+" option[value!='']").remove();
				data = $.parseJSON( data );
				for(i=0;i<data.DATA.length;i++)
				{
					var option = $('<option/>');
					if(selected && selected == data.DATA[i][0])
						option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
					else
						option.attr({ 'value': data.DATA[i][0] }).text(data.DATA[i][1]);
					$('#'+target).append(option);
				}
			}
		  }
	   });
}
function goFormDetail(option, url) 
	{
		window.location.href = url;
	}

</script>