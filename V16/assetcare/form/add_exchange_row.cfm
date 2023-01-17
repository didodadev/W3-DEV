<cfinclude template="../query/get_assetp_groups.cfm">
<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE = 1 ORDER BY ASSETP_CAT
</cfquery>

<cf_grid_list>
    <thead>
        <tr>
            <th width="20">
                <input name="record_num" id="record_num" type="hidden" value="0">
                <a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
            </th>
            <th><cf_get_lang dictionary_id='48098.Eski Araç'> *</th>
            <th><cf_get_lang dictionary_id='58847.marka'>/<cf_get_lang dictionary_id='30041.Marka Tipi'></th>
            <th><cf_get_lang dictionary_id='58225.Model'></th>
            <th><cf_get_lang dictionary_id='48099.Yeni Araç Tipi'> *</th>
            <th><cf_get_lang dictionary_id='47901.Kullanım Amacı'> *</th>
            <th><cf_get_lang dictionary_id='58847.marka'>/<cf_get_lang dictionary_id='30041.Marka Tipi'>*</th>
            <th><cf_get_lang dictionary_id='58225.Model'> *</th>
        </tr>
    </thead>
    <tbody name="table1" id="table1"></tbody>
</cf_grid_list>
<cfsavecontent variable="satir_process"><cf_workcube_process process_action_dsn="#dsn#" is_upd="0" process_cat_width="150" is_detail="0" is_reset='0' is_cancel='0'></cfsavecontent>
