<cfif isdefined('attributes.piece_id') and len(attributes.piece_id)>
	<cfif attributes.piece_name eq attributes.urun>
        <cfquery name="upd_piece_relation" datasource="#dsn3#">
            UPDATE       
                EZGI_DESIGN_PIECE_ROWS
            SET                
                PIECE_RELATED_ID = #attributes.sid#
            WHERE        
                PIECE_ROW_ID = #attributes.piece_id#
        </cfquery>
        <script type="text/javascript">
            alert('Ürün İlişkilendirme Başarıyla Tamamlandı!');
            wrk_opener_reload();
            window.close();
        </script>
    <cfelse>
        <script type="text/javascript">
            alert('İlişkilendirmek İstediğiniz Ürün Adları Aynı Olmalıdır.!');
            window.history.go(-1);
        </script>
    </cfif>
<cfelseif isdefined('attributes.package_id') and len(attributes.package_id)>
		<cfif attributes.package_name eq attributes.urun>
        <cfquery name="upd_piece_relation" datasource="#dsn3#">
            UPDATE       
                EZGI_DESIGN_PACKAGE_ROW
            SET                
                PACKAGE_RELATED_ID = #attributes.sid#
            WHERE        
                PACKAGE_ROW_ID = #attributes.package_id#
        </cfquery>
        <script type="text/javascript">
            alert('Ürün İlişkilendirme Başarıyla Tamamlandı!');
            wrk_opener_reload();
            window.close();
        </script>
    <cfelse>
        <script type="text/javascript">
            alert('İlişkilendirmek İstediğiniz Ürün Adları Aynı Olmalıdır.!');
            window.history.go(-1);
        </script>
    </cfif>

</cfif>