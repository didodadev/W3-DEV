<!---Sayfalardaki Grafiklerin Ajax ile yüklenmesi için iframe'den çağırılması gerektiği için ajax ile çağırılan tüm grafiklerin iframe bu dosyadan çağırılacak M.T--->
<cfif type eq 1>
	<!---Anket Güncelle - Anketle Grafiği--->
    <iframe 
        name="graph_name" 
        id="graph_name" 
        frameborder="0" 
        scrolling="no"
        width="100%" 
        height="400" 
        src="<cfoutput>#request.self#?fuseaction=campaign.popup_ajax_anket&survey_id=#attributes.survey_id#</cfoutput>&iframe=1">
    </iframe>
<cfelseif type eq 2>
	<!---Stok Detayı - Grafik--->
    <cf_box  title='#head#'
    scroll="1" 
    collapsable="1" 
    resize="1" 
    popup_box="#iif(isdefined("attributes.draggable"),1,0)#"
    id="stock_grp" 
    refresh="0"
    box_page="#request.self#?fuseaction=stock.popup_stock_graph_ajax&pid=#pid#&iframe=1">
    </cf_box>

<cfelseif type eq 3>
	<!---Kurumsal Üye Başvuruları - Kurumsal Üye Profili--->
    <iframe scrolling="no" 
        frameborder="0" 
        width="330" 
        height="435" 
        src="<cfoutput>#request.self#</cfoutput>?fuseaction=member.popup_comp_graph&iframe=1">
	</iframe>
<cfelseif type eq 4>
	<!---Bireysel Üye Başvuruları - Bireysel Üye Profili--->
	<iframe scrolling="no" 
        frameborder="0" 
        width="330" 
        height="300" 
        src="<cfoutput>#request.self#</cfoutput>?fuseaction=member.popup_cons_graph_ajax&iframe=1">
    </iframe>     
<cfelseif type eq 5>
	<!---Fiyat Detay - Birim - Fiyat Değişimleri--->
	<iframe 
        name="stock_graph" 
        id="stock_graph" 
        height="250" 
        width="100%"
        frameborder="0" 
        scrolling="no" 
        src="<cfoutput>#request.self#?fuseaction=product.popup_graph_price_standart&pid=#attributes.pid#</cfoutput>&iframe=1">
    </iframe> 
<cfelseif type eq 6>
	<!---Proje Detay - Durumlarına Göre Aktif Projeler--->
	<iframe 
        name="project_grp" 
        id="project_grp" 
        src="<cfoutput>#request.self#</cfoutput>?fuseaction=project.popup_ajax_project_graph&iframe=1" 
        frameborder="0"
        width="300" 
        height="290" 
        scrolling="no">
	</iframe>  
<cfelseif type eq 7>
	<!---Proje Detay - Durumlarına Göre Aktif İşler--->
	<iframe 
        name="project_grp_" 
        id="project_grp_" 
        src="<cfoutput>#request.self#</cfoutput>?fuseaction=project.popup_works_graph&iframe=1" 
        frameborder="0"
        width="300" 
        height="290" 
        scrolling="no">
	</iframe> 
<cfelseif type eq 8>
	<!---Katılımcı Son Test Sonuçları--->
    <cfif isdefined("attributes.class_id") and len(attributes.class_id)>
        <iframe 
            name="train_graph" 
            id="train_graph" 
            src="<cfoutput>#request.self#?fuseaction=training_management.popup_list_attainer_exam_result_graph&class_id=#class_id#&train_group_id=#attributes.train_group_id#&finishdate=#attributes.finishdate#&start_date=#attributes.start_date#</cfoutput>&iframe=1" 
            frameborder="0"
            width="100%"
            height="100%"
            scrolling="yes">
        </iframe>
    <cfelse>
        <iframe 
            name="train_graph" 
            id="train_graph" 
            src="<cfoutput>#request.self#?fuseaction=training_management.popup_list_attainer_exam_result_graph&train_group_id=#attributes.train_group_id#&finishdate=#attributes.finishdate#&start_date=#attributes.start_date#</cfoutput>&iframe=1" 
            frameborder="0"
            width="100%"
            height="100%"
            scrolling="yes">
        </iframe>
    </cfif>
<cfelseif type eq 9>
	<!---Eğitimci Değerlendirmeleri--->
    <cfif isdefined("attributes.class_id") and len(attributes.class_id)>
        <iframe 
            name="train_graph_" 
            id="train_graph_" 
            src="<cfoutput>#request.self#?fuseaction=training_management.popup_list_trainer_exam_result_graph&class_id=#class_id#&train_group_id=#attributes.train_group_id#&finishdate=#attributes.finishdate#&start_date=#attributes.start_date#</cfoutput>&iframe=1" 
            frameborder="0"
            width="100%"
            height="100%"
            scrolling="yes">
        </iframe>   
    <cfelse>
        <iframe 
            name="train_graph_" 
            id="train_graph_" 
            src="<cfoutput>#request.self#?fuseaction=training_management.popup_list_trainer_exam_result_graph&train_group_id=#attributes.train_group_id#&finishdate=#attributes.finishdate#&start_date=#attributes.start_date#</cfoutput>&iframe=1" 
            frameborder="0"
            width="100%"
            height="100%"
            scrolling="yes">
        </iframe>   
    </cfif>      
</cfif>
