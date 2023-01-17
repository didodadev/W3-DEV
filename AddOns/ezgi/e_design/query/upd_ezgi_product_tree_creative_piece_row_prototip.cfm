<cftransaction>
    <cfquery name="del_piece_prototip" datasource="#dsn3#">
        DELETE FROM EZGI_DESIGN_PIECE_PROTOTIP WHERE PIECE_ROW_ID = #attributes.design_piece_row_id#
    </cfquery>
    <cfquery name="del_piece_prototip_alternative" datasource="#dsn3#">
        DELETE FROM EZGI_DESIGN_PIECE_PROTOTIP_ALTERNATIVE WHERE PIECE_ROW_ID = #attributes.design_piece_row_id#
    </cfquery>
    <cfif not isdefined('attributes.is_delete')>
        <cfquery name="add_piece_prototip" datasource="#dsn3#">
            INSERT INTO 
                EZGI_DESIGN_PIECE_PROTOTIP
                (
                    PIECE_ROW_ID, 
                    QUESTION_ID, 
                    BOY_FORMUL, 
                    EN_FORMUL, 
                    IS_AMOUNT_CHANGE, 
                    IS_PRICE_CHANGE,
                    AMOUNT_FORMUL
                )
            VALUES        
                (
                    #attributes.design_piece_row_id#,
                    <cfif isdefined('attributes.alternative_question_id') and len(attributes.alternative_question_id)>#attributes.alternative_question_id#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.boy_formul') and len(attributes.boy_formul)>'#attributes.boy_formul#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.en_formul') and len(attributes.en_formul)>'#attributes.en_formul#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.is_amount') and len(attributes.is_amount)>1<cfelse>0</cfif>,
                    <cfif isdefined('attributes.is_price') and len(attributes.is_price)>1<cfelse>0</cfif>,
                    <cfif isdefined('attributes.amount_formul') and len(attributes.amount_formul)>'#attributes.amount_formul#'<cfelse>NULL</cfif>
                    )
        </cfquery>
        <cfif attributes.record_num gt 0>
            <cfloop from="1" to="#attributes.record_num#" index="i">
                <cfif isdefined('attributes.row_kontrol#i#') and Evaluate('attributes.row_kontrol#i#') eq 1>
                    <cfquery name="add_piece_prototip_alternative" datasource="#dsn3#">
                        INSERT INTO 
                            EZGI_DESIGN_PIECE_PROTOTIP_ALTERNATIVE
                            (
                                PIECE_ROW_ID, 
                                ALTERNATIVE_AMOUNT,
                                <cfif attributes.piece_type eq 4>
                                    ALTERNATIVE_STOCK_ID
                                <cfelse>
                                	ALTERNATIVE_PIECE_ROW_ID
                                </cfif>
                                
                            )
                        VALUES        
                            (
                                #attributes.design_piece_row_id#,
                                #FilterNum(Evaluate('attributes.quantity#i#'),4)#,
                              	#Evaluate('attributes.stock_id#i#')#
                            )
                    </cfquery>
                </cfif>
            </cfloop>
        </cfif>
 	</cfif>
</cftransaction>
<cflocation url="#request.self#?fuseaction=prod.popup_upd_ezgi_product_tree_creative_piece_row_prototip&design_piece_row_id=#attributes.design_piece_row_id#" addtoken="No">