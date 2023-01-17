<style>
.reportagenda{
    background: url(images/report_welcome/report-desk.png);
    background-position: left;
    background-repeat: no-repeat !important;
    padding: 0px !important;
    border: 0px;
    margin: 10px;
    height: 400px;
	width: 750px;
}

.reportagendatop{
	padding: 150px; 155px; 140px; 135px; !important;
	border: 0px;
	margin: 0px !important;
	height: 50px;

}	

.reportagendahead .iconlist {
    list-style: none;
    padding: 0;
}

.reportagendahead .iconlist li {
    font-size: 16px;
    height: 35px;
    padding: 7px 0;
    cursor: pointer;
    color: #00A713; !important;
    font-weight: 500;
}
	
	.reportagendahead .iconlist a {
    color: #535353; !important;
}

.reportagendahead .iconlist :hover {
    color: #F8060A;
}
</style>

<!--- Google API --->
<cfset getComponent = createObject('component','WEX.google.cfc.google_api')>
<cfset get_google_key = getComponent.get_api_key()>
<cfset get_component = createObject("component","V16.report.cfc.wai_settings") />
<cfset get_wai_settings = get_component.GET_WAI_SETTINGS() />
<cfif get_wai_settings.recordcount>
	<cfset user_name = get_wai_settings.name>
<cfelse>
	<cfset user_name = session.ep.name>
</cfif>

<div class="col col-12 col-md-12 col-sm-12">

	<cfinclude template="report_menu.cfm">

</div>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div class="voice-design">
			<i class="fa fa-microphone holistic-speech" href="javascript://" onclick="listening()"></i>
			<input type="text" placeholder="<cf_get_lang dictionary_id='64213.Siz Sorun Luna Cevaplasın'>- alfa" name="wai_text" id="wai_text">
			<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=report.wai_settings</cfoutput>','','ui-draggable-box-small')"> <i class="fa fa-question"></i></a>
			<i class="fa fa-volume-up"></i>
			<a class="" href="javascript://" onclick="getVoice();" id="play_func"><i class="icn-md catalyst-volume-1 volume-up" id="play" title="<cf_get_lang dictionary_id='62757.Sesli Oku'>"></i> </i></a>
			<a class="" href="javascript://" onclick="stopVoice();" id="stop_func"><i class="icn-md catalyst-volume-2 volume-up" id="pause" style="display:none" title="<cf_get_lang dictionary_id='62758.Durdur'>"></i> </i></a>
			<audio controls="" src="data:audio/ogg;base64," style="display:none" id="audio_control"  onended="$('#pause').hide(); $('#play').show();gif_control();">
			</audio>
		</div>
	</cf_box>
</div>
<div class="show-gif-design" id="show_gif">
	<img src="css/assets/luna.gif" width="200" height="200"/>
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Gündem',57413)#">
		 <div class="row">
		<div class="reportagenda" >
			<div class="row reportagendatop">
				<div class="col col-2 col-xs-12">
					<div class="reportagendahead">
						<ul class="iconlist">
							<li><a href="<cfoutput>#request.self#?</cfoutput>fuseaction=report.activity_summary"><cf_get_lang dictionary_id='59352.Yönetim'></a></li>
							<li><a <cfif get_module_user(86)> href="<cfoutput>#request.self#?</cfoutput>fuseaction=myhome.welcome_fa" <cfelse> href="javascript://" onclick="alert('<cfoutput><cf_get_lang dictionary_id='57532.Yetkiniz Yok'></cfoutput>')" </cfif>><cfoutput><cf_get_lang dictionary_id='57442.Finans'></cfoutput></a></li>
						</ul>
					</div>
				</div>
	
				<div class="col col-3 col-xs-12">
					<div class="reportagendahead" style="text-align: center">
						<ul class="iconlist">			
							<li><a <cfif get_module_user(11)> href="<cfoutput>#request.self#?</cfoutput>fuseaction=myhome.welcome_erp" <cfelse> href="javascript://" onclick="alert('<cfoutput><cf_get_lang dictionary_id='57532.Yetkiniz Yok'></cfoutput>')" </cfif>><cfoutput><cf_get_lang dictionary_id='57448.Satış'></cfoutput></a></li>
							<li><a <cfif get_module_user(74)> href="<cfoutput>#request.self#?</cfoutput>fuseaction=myhome.welcome_crm" <cfelse> href="javascript://" onclick="alert('<cfoutput><cf_get_lang dictionary_id='57532.Yetkiniz Yok'></cfoutput>')" </cfif>><cfoutput><cf_get_lang dictionary_id='59353.Müşteri Hizmetler'></cfoutput></a></li>
						</ul>
					</div>
				</div>
	
				<div class="col col-2 col-xs-12">
					<div class="reportagendahead">
						<ul class="iconlist">
							<li><a <cfif get_module_user(12)> href="<cfoutput>#request.self#?</cfoutput>fuseaction=purchase.dashboard" <cfelse> href="javascript://" onclick="alert('<cfoutput><cf_get_lang dictionary_id='57532.Yetkiniz Yok'></cfoutput>')" </cfif>><cfoutput><cf_get_lang dictionary_id='29745.Tedarik'></cfoutput></a></li>
							<li><a <cfif get_module_user(26)> href="<cfoutput>#request.self#?</cfoutput>fuseaction=myhome.welcome_production" <cfelse> href="javascript://" onclick="alert('<cfoutput><cf_get_lang dictionary_id='57532.Yetkiniz Yok'></cfoutput>')" </cfif>><cfoutput><cf_get_lang dictionary_id='57456.Üretim'></cfoutput></a></li>
						</ul>
					</div>
				</div>
				<div class="col col-2 col-xs-12">
					<div class="reportagendahead">
						<ul class="iconlist">
							<li style="text-align: right;"><a <cfif get_module_user(1)> href="<cfoutput>#request.self#?</cfoutput>fuseaction=report.project_summary" <cfelse> href="javascript://" onclick="alert('<cfoutput><cf_get_lang dictionary_id='57532.Yetkiniz Yok'></cfoutput>')" </cfif>><cfoutput><cf_get_lang dictionary_id='57416.Proje'></cfoutput></a></li>
							<li style="vertical-align: bottom; margin-left:20px"><a <cfif get_module_user(74)> href="<cfoutput>#request.self#?</cfoutput>fuseaction=myhome.welcome_crm" <cfelse> href="javascript://" onclick="alert('<cfoutput><cf_get_lang dictionary_id='57532.Yetkiniz Yok'></cfoutput>')" </cfif>><cfoutput><cf_get_lang dictionary_id='29405.Pazarlama'></cfoutput></a></li>
						</ul>
					</div>
				</div>
				<div class="col col-3 col-xs-12">
					<div class="reportagendahead" style="text-align: right;">
						<ul class="iconlist">
							<li><a <cfif get_module_user(86)> href="<cfoutput>#request.self#?</cfoutput>fuseaction=report.company_ekg" <cfelse> href="javascript://" onclick="alert('<cfoutput><cf_get_lang dictionary_id='57532.Yetkiniz Yok'></cfoutput>')" </cfif>><cfoutput><cf_get_lang dictionary_id='59354.Denetim'></cfoutput></a></li>
							​<li style="margin-top:-15px;"><a <cfif get_module_user(66)> href="<cfoutput>#request.self#?</cfoutput>fuseaction=myhome.welcome_hr" <cfelse> href="javascript://" onclick="alert('<cfoutput><cf_get_lang dictionary_id='57532.Yetkiniz Yok'></cfoutput>')" </cfif> ><cfoutput><cf_get_lang dictionary_id='57444.İnsan Kaynakları'></cfoutput></a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="ui-form-list flex-list">
			<div class="form-group large">
				<select>
					<option value="Haftanın Özeti" selected><cf_get_lang dictionary_id='64857.Haftanın Özeti'></option>
					<option value="Ayın Özeti"><cf_get_lang dictionary_id='877.Ayın Özeti'></option>
					<option value="Çeyrek Özet"><cf_get_lang dictionary_id='878.Çeyrek Özet'></option>
					<option value="Yıllık Özet"><cf_get_lang dictionary_id='64859.Yıllk Özet'></option>
				</select>
			</div>
			<div class="form-group">
				<a class="ui-btn ui-btn-green" href="javascript://"><i class="fa fa-volume-up"></i></a>
			</div>
		</div>
	</div> 
	</cf_box>
</div>

<script>
	var get_all_text = '';
	is_gif_control = 0;
	start_date = Date.now();
	finish_date = Date.now();
	try {
		var SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
		var recognition = new SpeechRecognition();
		//this.recognition.lang = "tr";
		recognition.maxAlternatives = 10;
		recognition.onresult = function(event) {

			$("#show_gif").attr('style',"display: flex !important");
			$("#wai_text").val(event.results[0][0].transcript);

			speech_text = event.results[0][0].transcript;
			
			
			$.ajax({ 
				type:'POST',  
				url:'V16/report/cfc/wai_settings.cfc?method=GET_WAI_DATE',  
				async:false,
				data: { 
					speech_text: speech_text
				},
				beforeSend: function() {
					if(!(speech_text.toLowerCase().includes('merhaba') || speech_text.toLowerCase().includes('selam') || speech_text.toLowerCase().includes('ne haber') || speech_text.toLowerCase().includes('naber')))
					{
						get_all_text = "<cf_get_lang dictionary_id='64241.Şuan üzerinde çalışıyorum'>";
						getVoice();
					}
				},
				success: function (returnData) {  // alt kategori varsa burası çalışacak

					var jDataQuestion = JSON.parse(returnData);
					if(jDataQuestion['DATA'].length > 0)
					{
						start_date = new Date(jDataQuestion['DATA'][0][0]);
						finish_date = new Date(jDataQuestion['DATA'][0][1]);
					}
					$.ajax({ 
						type:'POST',  
						url:'V16/report/cfc/wai_settings.cfc?method=GET_WAI_QUESTIONS',  
						async:false,
						data: { 
							speech_text: speech_text,
							start_date: start_date,
							finish_date: finish_date
						},
						success: function (returnData) {  // alt kategori varsa burası çalışacak
							var jData = JSON.parse(returnData);
							//Cevap içerisinde isim geçiyorsa
							
							if(jData['DATA'].length > 0){
								with_name = jData['DATA'][0][0].replace(/&&name&&/g,"<cfoutput>#user_name#</cfoutput>");
								get_all_text = with_name;
								
								getVoice(1);
							}else{
								get_all_text = "<cf_get_lang dictionary_id='64226.Soruyu Anlamadım'>";
								getVoice(1);
							}
						},
						error: function () 
						{
							console.log('CODE:1 please, try again..');
							return false; 
						}
					}); 
				},
				error: function () 
				{
					console.log('CODE:1 please, try again..');
					return false; 
				}
			}); 
			
			
			
			//Öneriler
			/*if (event.results.length > 0) {
				var result = event.results[0];
				for (var i = 0; i < result.length; ++i) {
					var text = result[i].transcript;
					select.options[i] = new Option(text, text);
				}
			}*/
		}
    }
    catch(e) {
      console.error(e);
    }
	//speech to text
	function listening() {

		recognition.start();

	}

	function stopVoice()
	{
		document.getElementById("audio_control").pause(); 
		$("#play").css("display","");
		
		$("#pause").css("display","none");
		
	}
	function playVoice()
	{
		document.getElementById("audio_control").play(); 
		$("#play").css("display","none");
		$("#pause").css("display","");
	}
	
	//wex
	/* TODO: Şirket akış parametrelerine google api key eklenecek. */
	function getVoice(type)
	{
		
		data = {
			"input": {
				"text": get_all_text
			}
		};
		$.ajax({
				url :'/wex.cfm/speechtotext/google_control',
				method: 'post',
				contentType: 'application/json; charset=utf-8',
				dataType: "json",
				data : JSON.stringify(data),
				success : function(response){ 
					parse_response = JSON.parse(response);
					document.getElementById("audio_control").src = "data:audio/ogg;base64,"+parse_response.audioContent;
					document.getElementById("audio_control").play(); 
					if(type)
						is_gif_control = 1;
					$("#play").css("display","none");
					$("#pause").css("display","");
					$("#play_func").attr("onclick","playVoice()"); 
				},error: function(response){ 
					alert("Google API KEY");
					is_gif_control = 1;
					gif_control();
				}
		}); 
		
	}
	function gif_control(){
		if(is_gif_control == 1){
			$('#show_gif').css('display','none');
			is_gif_control = 0;
		}
	}
</script>
