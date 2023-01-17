<div class="row">
	<div class="col col-12">
		<h3 class="workdevPageHead"><cfoutput>#getLang('main',724)#</cfoutput></h3>
	</div>
</div> 
<cfform action="#request.self#?fuseaction=protein.emptypopup_add_main_menu" method="post" name="user_group" enctype="multipart/form-data"> 
<div class="row" type="row">
	<div class="form-inline col col-12 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
		<div class="form-group" id="is_active">
			<label class="form-check-label">
				<input type="checkbox" name="is_active" id="is_active" value="1" checked> Aktif
			</label>
		</div> 
		<div class="form-group" id="is_publish">
			<label class="form-check-label">
				<input type="checkbox" name="is_publish" id="is_publish" value="1" checked> Bakım / Yayın
			</label>
		</div> 
	</div>
	<div class="form-inline col col-12 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
		<div class="form-group" id="site_type">
			<label class="form-check-label">
				<input type="radio" name="site_type" id="site_type" value="1" checked> Çalışan Portalı
			</label>
		</div> 
		<div class="form-group" id="site_type">
			<label class="form-check-label">
				<input type="radio" name="site_type" id="site_type" value="2" checked> Üye Portalı
			</label>
		</div> 
		<div class="form-group" id="site_type">
			<label class="form-check-label">
				<input type="radio" name="site_type" id="site_type" value="3" checked>  Kariyer Portalı
			</label>
		</div> 
		<div class="form-inline col col-12 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
			<div class="form-group" id="sitel-ekleme">
				<label class="form-check-label">
					<label class="col col-12"><b><cfoutput>#getLang('call',69)#</cfoutput></label>
				</label>
			</div> 	
		</div>
		<div class="form-inline col col-12 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
			<div class="form-group" id="sitel-ekleme">
				<label class="form-check-label">
					<input type="text" name="menu_name" id="menu_name" value=""  required="yes" message="Site Adı Girmelisiniz!" maxlength="100">
				</label>
			</div> 	

			<div class="form-group">
		       <cf_workcube_buttons is_upd='0'>
	          </div>
	      </div>

		</div>
		
</cfform>
