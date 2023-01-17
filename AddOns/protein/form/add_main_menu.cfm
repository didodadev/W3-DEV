<div class="row">
	<div class="col col-12">
		<h3 class="workdevPageHead"><cfoutput>#getLang('main',724)#</cfoutput></h3>
	</div>
</div> 
<cfform action="#request.self#?fuseaction=protein.emptypopup_add_main_menu" method="post" name="user_group" enctype="multipart/form-data"> 
<div class="row" type="row">
	<div class="col col-3 col-md-8 col-md-12" type="column" sort="true" index="1">
		<div class="box-authentication">
			<div class="checkbox-group">
				<label class="form-check-label">
					<input type="checkbox" name="is_active" id="is_active" value="1" checked> Aktif
				</label>
				<label class="form-check-label">
					<input type="checkbox" name="is_publish" id="is_publish" value="1"> Bakım / Yayın
				</label>
			</div>
			<div class="checkbox-group">	
				<label class="form-check-label">
					<input type="radio" name="site_type" id="site_type" value="1"> Çalışan Portalı
				</label>	
				<label class="form-check-label">
                    <input type="radio" name="site_type" id="site_type" value="2"> Üye Portalı
				</label>	
				<label class="form-check-label">
                    <input type="radio" name="site_type" id="site_type" value="3"> Kariyer Portalı
				</label>	
				<!---<label class="form-check-label">
                    <input type="radio" name="site_type" id="site_type" value="4"> PDA Portalı
                </label>--->
			</div>
		</div>
		<div class="form-group" id="sitel-ekleme">
			<label class="col col-12"><b><cfoutput>#getLang('call',69)#</cfoutput></label>
			<div class="col col-12">
			   <cfinput type="text" name="menu_name" id="menu_name" value="" style="width:200px;" required="yes" message="Site Adı Girmelisiniz!" maxlength="100">
			</div>
		</div>
	</div>
</div>
<div class="row form-inline">
	<div class="col col-3"></div>
	<div class="form-group">
		<cf_workcube_buttons is_upd='0'>
	</div>
</div>
</cfform>
