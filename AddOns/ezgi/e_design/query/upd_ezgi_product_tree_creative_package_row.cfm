<!---Eğer Ortak Paket Üzerinden Geliyorsa Kendi Kaydında Sadece Miktar ve Paket No Değişecek Diğer Bilgiler Ortak Master Paket Üzerinde Değişecek--->
<cftransaction>
	<cfif isdefined('attributes.design_package_partner_id') and len(attributes.design_package_partner_id)> 
        <cfquery name="upd_package" datasource="#dsn3#">
            UPDATE
                EZGI_DESIGN_PACKAGE_ROW
            SET
            	PACKAGE_NUMBER = <cfif len(attributes.paket_number)>#attributes.paket_number#<cfelse>0</cfif>,
                PACKAGE_AMOUNT = <cfif len(attributes.paket_amount)>#attributes.paket_amount#<cfelse>1</cfif>,
                PACKAGE_PARTNER_ID = #attributes.design_package_partner_id#,
                PACKAGE_IS_MASTER = 0
            WHERE
                PACKAGE_ROW_ID = #attributes.design_package_row_id#  
        </cfquery>         	
    </cfif>
    <cfquery name="upd_package" datasource="#dsn3#">
        UPDATE
            EZGI_DESIGN_PACKAGE_ROW
        SET
	    PACKAGE_NUMBER = <cfif len(attributes.paket_number)>#attributes.paket_number#<cfelse>0</cfif>,
            PACKAGE_COLOR_ID = <cfif len(attributes.color_type)>'#attributes.color_type#'<cfelse>NULL</cfif>, 
            PACKAGE_NAME = <cfif len(attributes.design_name_package_row)>'#attributes.design_name_package_row#'<cfelse>NULL</cfif>, 
            PACKAGE_BOYU = <cfif len(attributes.paket_boy)>#FilterNum(attributes.paket_boy)#<cfelse>NULL</cfif>, 
            PACKAGE_ENI = <cfif len(attributes.paket_en)>#FilterNum(attributes.paket_en)#<cfelse>NULL</cfif>, 
            PACKAGE_KALINLIK = <cfif len(attributes.paket_kalinlik)>#FilterNum(attributes.paket_kalinlik)#<cfelse>NULL</cfif>, 
            PACKAGE_WEIGHT = <cfif len(attributes.paket_weight)>#FilterNum(attributes.paket_weight)#<cfelse>NULL</cfif>
            <cfif isdefined('attributes.design_package_partner_id') and len(attributes.design_package_partner_id)>
                
            <cfelse>
                ,PACKAGE_AMOUNT = <cfif len(attributes.paket_amount)>#attributes.paket_amount#<cfelse>1</cfif>, 
                PACKAGE_PARTNER_ID = NULL,
                PACKAGE_IS_MASTER = <cfif isdefined('attributes.package_is_master') and len(attributes.package_is_master)>1<cfelse>NULL</cfif>
            </cfif>
        WHERE
            <cfif isdefined('attributes.design_package_partner_id') and len(attributes.design_package_partner_id)>
                PACKAGE_ROW_ID = #attributes.design_package_partner_id# 
            <cfelse>
                PACKAGE_ROW_ID = #attributes.design_package_row_id# 
            </cfif>
    </cfquery>
</cftransaction>
<script type="text/javascript">
        wrk_opener_reload();
        window.close();
</script>