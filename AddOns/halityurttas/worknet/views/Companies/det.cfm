<cfinclude template="../../config.cfm">
<cf_xml_page_edit fuseact="member.detail_company" is_multi_page="1">
    <cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
    <cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.Companies.member") />
    <cfset getCompany = cmp.getCompany(company_id:attributes.cpid,company_status:'') />
    <cfset getPartner = cmp.getPartner(company_id:attributes.cpid,partner_status:'') />
    <cfset getReqType = cmp.getReqType(company_id:attributes.cpid) />
    <!---<cfset getMobilcat = cmp.getMobilcat() />--->
    <cfset getCountry = cmp.getCountry() />
    <cfset getProductCat = cmp.getProductCat(company_id:attributes.cpid) />
    <cfset pageHead="ÜYE: #getCompany.nickname#">
    <cf_catalystHeader>
    
    <div class="row">
        <div class="col col-9 col-xs-12 uniqueRow" id="content">
            <cfinclude template="_det_content.cfm">
        </div>
        <div class="col col-3 col-xs-12 uniqueRow" id="side">
            <cfinclude template="_det_right.cfm">
        </div>
        <div class="col col-12">
            <cfinclude template="_det_bottom.cfm">
        </div>
    </div>
    
    <script type="text/javascript">
    function remove_field(field_option_name)
    {
        field_option_name_value = document.getElementById(field_option_name);
        for (i=field_option_name_value.options.length-1;i>-1;i--)
        {
            if (field_option_name_value.options[i].selected==true)
            {
                field_option_name_value.options.remove(i);
            }	
        }
    }
    function select_all(selected_field)
    {
        var m = eval("document.form_upd_company." + selected_field + ".length");
        for(i=0;i<m;i++)
        {
            eval("document.form_upd_company."+selected_field+"["+i+"].selected=true");
        }
    }
    function LoadPhone(x)
    {
        if(x != '')
        {
            get_phone_no = wrk_safe_query("mr_get_phone_no","dsn",0,x);
    
            if(get_phone_no.COUNTRY_PHONE_CODE != undefined && get_phone_no.COUNTRY_PHONE_CODE != '')
                document.getElementById('load_phone').innerHTML = '(' + get_phone_no.COUNTRY_PHONE_CODE + ')';
            else
                document.getElementById('load_phone').innerHTML = '';
        }
        else
            document.getElementById('load_phone').innerHTML = '';
    }
    function kontrol()
    {
        select_all('product_category');
        if(document.getElementById('fullname').value == "")
        {
            alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='159.Ünvan'>!");
            document.getElementById('fullname').focus();
            document.getElementById('fullname').style.backgroundColor = '#FF6600';
            return false;
        }
        else document.getElementById('fullname').style.backgroundColor = '';
        
        if(document.getElementById('nickname').value == "")
        {
            alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='339.kisa Ad'>!");
            document.getElementById('nickname').focus();
            document.getElementById('nickname').style.backgroundColor = '#FF6600';
            return false;
        }
        else document.getElementById('nickname').style.backgroundColor = '';
        
        x = document.getElementById('companycat_id').selectedIndex;
        if (document.form_upd_company.companycat_id[x].value == "")
        { 
            alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='131.Sirket Kategorisi '>!");
            document.getElementById('companycat_id').focus();
            return false;
        }
        /*if (document.getElementById('firm_type').value == "")
        { 
            alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:Firma Tipi!");
            return false;
        }
        if(document.getElementById('product_category').value == '' )
        {
            alert("Ürün Kategorisi Seçmelisiniz !");
            document.getElementById('product_category').focus();
            return false;
        }*/
        if (document.getElementById('manager_partner_id').value == "")
        { 
            alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1714.Yönetici'>!");
            return false;
        }
        
        if(document.getElementById('company_telcode').value == "")
        {
            alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='178.Telefon Kodu'> !");
            document.getElementById('company_telcode').focus();
            document.getElementById('company_telcode').style.backgroundColor = '#FF6600';
            return false;
        } else document.getElementById('company_telcode').style.backgroundColor = '';
        
        if(document.getElementById('company_tel1').value == "")
        {
            alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='87.Telefon'> !");
            document.getElementById('company_tel1').focus();
            document.getElementById('company_tel1').style.backgroundColor = '#FF6600';
            return false;
        } else document.getElementById('company_tel1').style.backgroundColor = '';
        
        if(document.form_upd_company.process_stage.value == "")
        {
            alert("<cf_get_lang no='393.Lütfen Süreçlerinizi Tanımlayınız Yada Süreçler Üzerinde Yetkiniz Yok'>!");
            return false;
        }
        if(process_cat_control())
            if(confirm("<cf_get_lang no='175.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!"));
        else
            return false;
    
        return true;
    }
    
    function gizle_goster_detail(id)
    {
        if(document.getElementById(id).style.display == '' || document.getElementById(id).style.display == 'block' )
        {
            document.getElementById(id).style.display = 'none';
        } else {
            document.getElementById(id).style.display ='';
        }
    }
    
    function counter(id1,id2)
         { 
            if (document.getElementById(id1).value.length > 1500) 
              {
                    document.getElementById(id1).value = document.getElementById(id1).value.substring(0, 1500);
                    alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 1500");  
               }
            else 
                document.getElementById(id2).value = 1500 - (document.getElementById(id1).value.length); 
         } 
        counter('company_detail','detailLen');
        counter('company_detail_eng','detailLen_eng');
        counter('company_detail_spa','detailLen_spa');
    
    document.getElementById('fullname').focus();
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
    