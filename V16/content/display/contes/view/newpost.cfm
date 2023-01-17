<cfparam name="attributes.postId" default="">
<meta charset="UTF-8">
<div class="row contes">
	<div class="col col-12 contesRow">
		<div class="cntTableContainer">
			<div class="cntTableHeader <cfif len(#attributes.postId#)>update</cfif>">
				<span class="cntTableHeaderText"><cfif isdefined("attributes.postId") AND len(#attributes.postId#)><i class="material-icons pull-left">mode_edit</i>&nbsp;<cfelse><i class="material-icons pull-left">playlist_add</i>&nbsp;<cf_get_lang dictionary_id="54728.Yeni Yazı Ekle"></cfif></span>
				<ul class="cntTableHeaderBtns">
					<li><a href="#home"><i class="fa fa-undo"></i></a></li>					
				</ul>
			</div>
			<div id="returnmessage"></div>
			<div class="ctnBody">
				<div class="row" data-action="<cfif isdefined("attributes.postId") AND len(#attributes.postId#)>post_upd<cfelse>post_add_new</cfif>">
					<div class="col col-9 col-sm-12">
						<div class="input-field col s12">
							<input data-field="postHead" data-rq="true" id="postHead" type="text">
							<label for="postHead"><cf_get_lang dictionary_id="58820.Başlık"></label>
						</div>
						<div class="input-field col s12">
							<textarea id="postDescription" data-field="postDescription" data-rq="true"  class="materialize-textarea" ></textarea>
							<label for="postDescription"><cf_get_lang dictionary_id="58052.Özet"></label>
						</div>
						<div class="input-field col s12">
							<input data-field="postURL" id="postURL" type="text">
							<label for="postURL"><cf_get_lang dictionary_id="50659.Kullanıcı Dostu URL"></label>
						</div>
						<div class="input-field col l2 m3 s12">
							<input type="date" id="postDate" data-field="postDate" data-rq="true" class="datepicker">
							<label for="postDate"><cf_get_lang dictionary_id="58184.Yazım Tarihi"></label>
						</div>
						<div class="input-field col l2 m3 s12">
							<input type="date" id="postStartDate" data-field="postStartDate" data-rq="true"  class="datepicker">
							<label for="postStartDate"><cf_get_lang dictionary_id="50575.Yayın Başlangıç"></label>
						</div>
						<div class="input-field col l2 m3 s12">
							<input type="date" id="postFinishDate" data-field="postFinishDate" class="datepicker">
							<label for="postFinishDate"><cf_get_lang dictionary_id="50700.Yayın Bitiş"></label>
						</div>
						<div class="input-field col l2 m3 s12">
							<select id="postLanguage" name="postLanguage" data-field="postLanguage" data-rq="true" >
								<option value="" disabled selected><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<option value="tr"><cf_get_lang dictionary_id="38745.Türkçe"></option>
								<option value="eng"><cf_get_lang dictionary_id="38746.İngilizce"></option>
								<option value="de"><cf_get_lang dictionary_id="45088.Almanca"></option>
							</select>
							<label for="postLanguage"><cf_get_lang dictionary_id="58996.Dil"></label>
						</div>						
						<div class="input-field col l3 m3 s12">
							<input type="text" id="postAuthor" data-field="postAuthor" class="autocomplete">
							<label for="postAuthor"><cf_get_lang dictionary_id="47687.Yazar"></label>
						</div>
						<div class="row">				
							<cfmodule
							template="/fckeditor/fckeditor.cfm"
							toolbarset="WRKContent"
							basepath="/fckeditor/"
							checkbrowser = "true"
							instancename="POST_BODY"
							valign="top"
							value=""
							width="100%"
							height="400">
						</div>	
					</div>
					<div class="col col-3 col-sm-12 ">
						<ul class="collection with-header">
							<li class="collection-header"><h6><cf_get_lang dictionary_id="57435.Ayarlar"></h6></li>
							<li class="collection-item">
								<div class="switch">
									<label>
									<cf_get_lang dictionary_id="57494.Pasif">
									<input type="checkbox" id="postStatus" data-field="postStatus">
									<span class="lever"></span>
									<cf_get_lang dictionary_id="57493.Aktif">
									</label>
								</div>
							</li>
							<li class="collection-item">
								<input type="checkbox" id="postSpot" data-field="postSpot" />
								<label class="padding-top-5" for="postSpot"><cf_get_lang dictionary_id="54726.Anasayfa Spot"></label>
							</li>
						</ul>
						<div class="input-field col s12">
							<select multiple id="postSites" data-field="postSites" data-rq="true" ><option value="" disabled selected><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							</select>
							<label for="postSites"><cf_get_lang dictionary_id="47869.Site"></label>
						</div>
						<div class="input-field col s12">
							<select id="postCategory" data-field="postCategory" data-rq="true">
								<option value="" disabled selected><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							</select>
							<label for="postCategory"><cf_get_lang dictionary_id="57486.Kategori"></label>
						</div>
						<div class="input-field col s12">
							<select id="postChapter" data-field="postChapter">
								<option value="" disabled selected><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							</select>
							<label for="postChapter"><cf_get_lang dictionary_id="57995.Bölüm"></label>
						</div>
						<div class="input-field col s12">
							<input data-field="metaHead" id="metaHead" type="text">
							<label for="metaHead"><cf_get_lang dictionary_id="58983.Meta Başlığı"></label>
						</div>
						<div class="input-field col s12">
							<textarea id="metaDescription" data-field="metaDescription" rows="3" class="materialize-textarea" ></textarea>
							<label for="metaDescription"><cf_get_lang dictionary_id="58983.Meta Başlığı"></label>
						</div>
						<div class="input-field col s12">
							<textarea id="metaKeyword" data-field="metaKeyword" rows="2" class="materialize-textarea" ></textarea>
							<label for="metaKeyword"><cf_get_lang dictionary_id="58994.Meta Anahtar Kelimeler"> <small> * <cf_get_lang dictionary_id="54729.kelimeleri virgül ile ayır</small></label>
						</div>
						<cfif isdefined("attributes.postId") AND len(#attributes.postId#)>
							<button class="btn waves-effect waves-light" data-button="updPost" data-key="<cfoutput>#attributes.postId#</cfoutput>" name="action"><cf_get_lang dictionary_id="57464.Güncelle"></button>
						<cfelse>
							<button class="btn waves-effect waves-light" data-button="newPost"  type="submit"><cf_get_lang dictionary_id="59031.Kaydet"></button>
						</cfif>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
$(function() {	
	
	categorySelect = function(e,s){
		$.ajax({
            type: "GET",
			url: '/V16/content/display/contes/cfc/components.cfc?method=GET_POSTCAT_JSON&LANGUAGE_ID='+e,
            cache: false,
            success: function(data){
                var jData = JSON.parse(data);   
				$('#postCategory').empty();
				$('#postCategory').append('<option value="" disabled selected>Seçiniz</option>');             
                $.each( jData['DATA'], function( index ) { 					                         
						$('<option>').attr({value:this[0]})
						.append(this[1]).appendTo('#postCategory');                                     
                });
				$('#postCategory').val(s);			
				$('#postCategory').material_select();
            },
    	});//Kategori Select	
	}

	chapterSelect = function(e,s){
		$.ajax({
            type: "GET",
			url: '/V16/content/display/contes/cfc/components.cfc?method=GET_POSTCHAPTER_JSON&CONTENTCAT_ID='+e,
            cache: false,
            success: function(data){
                var jData = JSON.parse(data);   
				$('#postChapter').empty();
				$('#postChapter').append('<option value="" disabled selected>Seçiniz</option>');             
                $.each( jData['DATA'], function( index ) { 					                         
						$('<option>').attr({value:this[0]})
						.append(this[1]).appendTo('#postChapter');                                     
                });	
				$('#postChapter').val(s);					
				$('#postChapter').material_select();
            },
    	});//Bolum Select
	}

	$("#postLanguage").change(function() {
		categorySelect($(this).val());
	});

	$("#postCategory").change(function() {
		chapterSelect($(this).val());		
	});

	$("#postDate").change(function() {
		$('#postStartDate').val($(this).val());
		Materialize.updateTextFields();		
		$("#postDate").off("change");
	});// yazim tarihi secildiginde yayin tarihinide sec, ilk kullanımda

	
	$.ajax({
            type: "GET",
            url: "/V16/content/display/contes/cfc/components.cfc?method=GET_SITES_JSON",
            cache: false,
            success: function(data){
                var jData = JSON.parse(data);                
                $.each( jData['DATA'], function( index ) {                       
						$('<option>').attr({value:this[0]})
						.append(this[1]).appendTo('#postSites');                                     
                });
				$('#postSites').material_select();
            },
    	});//Siteler Select

	$('select').material_select();

    $('.datepicker').pickadate({
		selectMonths: true, // Creates a dropdown to control month
		selectYears: 50, // Creates a dropdown of 50 years to control year
		format: dateformat_style
	});

<cfif len(attributes.postId) >
console.log('güncelleme sayfası');
	
	$.ajax({
            type: "GET",
            url: "/V16/content/display/contes/cfc/components.cfc?method=GET_POST_JSON&postId=<cfoutput>#attributes.postId#</cfoutput>",
            cache: false,
            success: function(data){
                var jData = JSON.parse(data);  
				console.log(jData);
				$.each( jData['DATA'], function( index ) {   
						var postBody = this[0];
						$('[data-field="postDescription"]').val(this[1]);             
						$('[data-field="postHead"]').val(this[2]);
						$('.cntTableHeaderText').append(this[2]);
						$('[data-field="postDate"]').val(this[10]); 
						$('[data-field="postStartDate"]').val(this[11]); 
						$('[data-field="postFinishDate"]').val(this[12]);
						$('[data-field="postLanguage"]').val(this[14]);						
						$('[data-field="postAuthor"]').val(this[6]).attr('data-id',this[5]);					
						categorySelect(this[14],this[4]);
						chapterSelect(this[4],this[3]);
						$('[data-field="postStatus"]').prop('checked', this[9]);
						$('[data-field="postSpot"]').prop('checked', this[13]);
						if(this[8]){
							var dataSites=this[8].split(",");						
							$('[data-field="postSites"]').val(dataSites);
						};
						$('[data-field="metaHead"]').val(this[16]);	
						$('[data-field="metaDescription"]').val(this[17]);	
						$('[data-field="metaKeyword"]').val(this[18]);
						$('[data-field="postURL"]').val(this[19]);						
						$('select').material_select();
						Materialize.updateTextFields();
						setTimeout(function(){					
							CKEDITOR.instances.POST_BODY.setData(postBody);					
						}, 500);
						
                });				
            }
    	});// upd set field
		
</cfif>
	$( "#postAuthor" ).click(function() {
	$.ajax({
			type: "GET",
			url: "/V16/content/display/contes/cfc/components.cfc?method=GET_USERS_JSON",
			cache: false,
			success: function(data){
				var jData = JSON.parse(data);  
				var users = '{';
				$.each( jData['DATA'], function( index ) {  
					var name = this[1];
					if(this[2]){
						var photo = '../documents/hr/'+this[2];
					}else{
						if(this[3]){
							var photo = '../images/male.jpg';
						}else{
							var photo = '../images/female.jpg';
						}
					}
					var userId = this[0];
					if(index>0)users+=',';
					var item = 	'"'+name+'":{"photo":"'+photo+'","id":'+userId+'}';
					users+=item;
				}); 
				users+='}'

				$('input#postAuthor').autocomplete({
					data: JSON.parse(users),
					//limit: 5, // The max amount of results that can be shown at once. Default: Infinity.
					onAutocomplete: function(val) {
						
					},
					minLength: 3, // The minimum length of the input for the autocomplete to start. Default: 1.
				});               
			},
		});// autocomplete users
	});

});//ready

</script>
