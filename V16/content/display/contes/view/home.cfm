<cfset get_sites_action = createObject('component','V16.content.display.contes.cfc.components')>
<cfset get_sites = get_sites_action.GET_SITES()>
<div class="row">
	<div class="col col-12 contesRow">
		<div class="quick-actions_homepage">
			<ul class="quick-actions">
				<li class="bg_lb"> <a href="#sites"> <i class="fa fa-dashboard"></i> <span class="label label-important"><cfoutput>#get_sites.RecordCount#</cfoutput></span>Siteler</a> </li>
				<li class="bg_lg span3"> <a href=""> <i class="fa fa-signal"></i> Raporlar</a> </li>
				<li class="bg_ly"> <a href="#category"> <i class="fa fa-inbox"></i>Kategoriler </a> </li>
				<li class="bg_lo span2"> <a href=""> <i class="fa fa-th"></i> Galeri</a> </li>
				<li class="bg_ls"> <a href=""> <i class="fa fa-question"></i> Yardım</a> </li>
				<li class="bg_lo span3"> <a href=""> <i class="fa fa-th-list"></i> Formlar</a> </li>
				<li class="bg_ls"> <a href=""> <i class="fa fa-tint"></i> Şablonlar</a> </li>
				<li class="bg_lb span2"> <a href="#newpost"> <i class="fa fa-pencil"></i>Yazı Ekle</a> </li>
				<li class="bg_lg" > <a href=""> <i class="fa fa-calendar"></i> Etkinlik</a> </li>
				<li class="contes-bg"> <a href=""></a></li>
			</ul>
		</div>
	</div>
</div>
<div class="contes">
	<!-- Modal Structure -->
	<div id="modalSearchPost" class="modal-sa modal-fixed-footer" data-action="GET_POST_JSON">
		<div class="modal-sa-content">
			<h5>İçerik Ara</h5>
			<div class="row">
				<div class="input-field col s12">
					<input data-field="searchKey" id="searchKey" type="text">
					<label for="searchKey" data-error="wrong">Ara..</label>
				</div>
			</div>
			<div class="row">					
				<div class="input-field col m4 s12">
					<select multiple id="postSites" data-field="postSites" ><option value="" disabled selected>Seçiniz</option>
					</select>
					<label for="postSites">Site</label>
				</div>
				<div class="input-field col l2 m3 s12">
					<select id="postLanguage" name="postLanguage" data-field="postLanguage">
						<option value="" selected>Seçiniz</option>
						<option value="tr">Türkçe</option>
						<option value="eng">İngilizce</option>
						<option value="de">Almanca</option>
					</select>
					<label for="postLanguage">Dil</label>
				</div>
				<div class="input-field col m3 s12">
					<select id="postCategory" data-field="postCategory">
						<option value=""  selected><cf_get_lang dictionary_id="57734.Seçiniz"></option>
					</select>
					<label for="postCategory"><cf_get_lang dictionary_id="57486.Kategori"></label>
				</div>
				<div class="input-field col m3 s12">
					<select id="postChapter" data-field="postChapter">
						<option value="" selected><cf_get_lang dictionary_id="57734.Seçiniz"></option>
					</select>
					<label for="postChapter"><cf_get_lang dictionary_id="57995.Bölüm"></label>
				</div>
			</div>
			<div class="row">
				<div class="input-field col m3 s12">
					<select id="postStatus" data-field="postStatus">
						<option value="" selected><cf_get_lang dictionary_id="57708.Tümü"></option>
						<option value="1"><cf_get_lang dictionary_id="57493.Aktif"></option>
						<option value="0"><cf_get_lang dictionary_id="57494.Pasif"></option>
					</select>
					<label for="postStatus"><cf_get_lang dictionary_id="57756.Durum"></label>								
				</div>
				<div class="input-field col m3 s12">
					<input type="checkbox" id="postSpot" data-field="postSpot" />
					<label class="padding-top-5" for="postSpot"><cf_get_lang dictionary_id="54726.Anasayfa Spot"></label>
				</div>
				<div class="input-field col m3 s12">
					<input type="checkbox" id="postSorter" data-field="postSorter"/>
					<label class="padding-top-5 red-text text-lighten-2" for="postSorter">Sorter <i class="material-icons pull-right">swap_vert</i></label>
				</div>
			</div>
		</div>
		<div class="modal-sa-footer">
			<button class="btn waves-effect waves-light green margin-left-10" data-button="searchPost"><cf_get_lang dictionary_id="57565.Ara"></button>
			<button class="modal-action modal-sa-close btn waves-effect waves-light red"><cf_get_lang dictionary_id="57462.Vazgeç"></button>		
		</div>
	</div>
</div>
<div class="row">
	<div class="col col-12 uniqueRow">
		<div class="cntTableContainer">
			<div class="cntTableHeader">
				<span class="cntTableHeaderText"><cf_get_lang dictionary_id="58045.İçerikler"></span>
				<ul class="cntTableHeaderBtns">
					<li data-button="sortSave" class="pulse" style="display:none;"><cf_get_lang dictionary_id="54727.Sırayı Kaydet"></li>
					<li><a href="" data-target="modalSearchPost"><i class="large material-icons" ><cf_get_lang dictionary_id="47641.search"></i></a></li>
					<li><a href="#newpost"><i class="pulse large material-icons">playlist_add</i></a></li>				
				</ul>
			</div>
			<div id="returnmessage"></div>
			<table class="cntTable" id="postList" data-action="post">
				<thead>
					<tr>
						<th>#</th>
						<th><cf_get_lang dictionary_id="58820.Başlık"></th>
						<th><cf_get_lang dictionary_id="58184.Yazım Tarihi"></th>
						<th><cf_get_lang dictionary_id="47687.Yazar"></th>
						<th></th>
					</tr>
				</thead>
				<tbody id="postRows">
				</tbody>
			</table>
			<div paging class="contes">
				<div class="row">
					<div class="col s12" id="postsPaging">
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
				$('#postCategory').append('<option value="" selected>Seçiniz</option>');             
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
				$('#postChapter').append('<option value="" selected>Seçiniz</option>');             
				$.each( jData['DATA'], function( index ) { 					                         
						$('<option>').attr({value:this[0]})
						.append(this[1]).appendTo('#postChapter');                                     
				});	
				$('#postChapter').val(s);					
				$('#postChapter').material_select();
			},
		});//Bolum Select
	}

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
	
	$('.modal-sa').modal();
	
	$('select').material_select();

	$("#postLanguage").change(function() {
		categorySelect($(this).val());
	});

	$("#postCategory").change(function() {
		chapterSelect($(this).val());		
	});

	searchData 	= '';// search boşalt
	$.ajax({		
		type: "GET",
		url: "/V16/content/display/contes/cfc/components.cfc?method=GET_POST_JSON&record_count=1",
		data: searchData,
		cache: false,
		success: function(data){					
			$('#postsPaging').materializePagination({
				align: 'center',
				lastPage:  Math.ceil(data/25),
				firstPage:  1,
				useUrlParameter: false,
				onClickCallback: function(requestedPage){			
				},
				CallBackContes: function(callBack){
					if(callBack.status=="next" || callBack.status=="prev"){
							$('#postsPaging [data-page="'+callBack.current+'"]').trigger('click');
					}				
				},
			}); 
			$('#postsPaging [data-page="1"]').trigger('click');
		}			
	});	

	
				
	
		
});//ready
</script>