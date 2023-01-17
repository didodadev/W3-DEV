<cfif is_account>
	<cfif INVOICE_CAT eq 50>
		<cfset cash_acc_code= GET_NO_.VADE_F_F >
		<cfset DETAIL_=	"#getLang('main',415)#"><!--- VERİLEN VADE FARKI FATURASI--->
	<cfelseif INVOICE_CAT eq 51>
		<cfset cash_acc_code= GET_NO_.A_VADE_F_F >
		<cfset DETAIL_=	"#getLang('main',351)#"><!--- ALINAN VADE FARKI FATURASI--->
	<cfelseif INVOICE_CAT eq 52>
		<cfset cash_acc_code= GET_NO_.PERAKENDE_S_F >
		<cfset DETAIL_=	"#getLang('main',353)#"><!---PERAKENDE SATIŞ FATURASI --->
	<cfelseif INVOICE_CAT eq 53>
		<cfset cash_acc_code= GET_NO_.TOPTAN_F_F >
		<cfset DETAIL_= "#getLang('main',413)#"><!---TOPTAN SATIŞ FATURASI --->
	<cfelseif INVOICE_CAT eq 54>
		<cfset cash_acc_code= GET_NO_.PERAKENDE_S_I_F >
		<cfset DETAIL_=	"#getLang('main',412)#"><!---PERAKENDE SATIS IADE FATURASI --->
	<cfelseif INVOICE_CAT eq 55>
		<cfset cash_acc_code= GET_NO_.TOPTAN_S_I_F >
		<cfset DETAIL_=	"#getLang('main',356)#"><!---TOPTAN SATIS IADE FATURASI --->
	<cfelseif INVOICE_CAT eq 56>
		<cfset cash_acc_code= GET_NO_.VERILEN_H_F >
		<cfset DETAIL_=	"#getLang('main',417)#"><!--- VERİLEN HIZMET FATURASI--->
	<cfelseif INVOICE_CAT eq 57>
		<cfset cash_acc_code= GET_NO_.VERILEN_P_F >
		<cfset DETAIL_=	"#getLang('main',358)#"><!--- VERİLEN PROFORMA FATURASI--->
	<cfelseif INVOICE_CAT eq 58>
		<cfset cash_acc_code= GET_NO_.VERILEN_F_F >
		<cfset DETAIL_=	"#getLang('main',418)#"><!---VERİLEN FIYAT FARKI FATURASI --->
	<cfelseif INVOICE_CAT eq 59>
		<cfset cash_acc_code= GET_NO_.MAL_A_F >
		<cfset DETAIL_=	"#getLang('main',410)#"><!---MAL ALIM FATURASI --->
	<cfelseif INVOICE_CAT eq 60>
		<cfset cash_acc_code= GET_NO_.ALINAN_H_F >
		<cfset DETAIL_=	"#getLang('main',401)#"><!---ALINAN HIZMET FATURASI --->
	<cfelseif INVOICE_CAT eq 61>
		<cfset cash_acc_code= GET_NO_.ALINAN_P_F >
		<cfset DETAIL_=	"#getLang('main',402)#"><!---ALINAN PROFORMA FATURASI --->
	<cfelseif INVOICE_CAT eq 62>
		<cfset cash_acc_code= GET_NO_.ALIM_I_F >
		<cfset DETAIL_=	"#getLang('main',403)#"><!---ALIM IADE FATURASI --->
	<cfelseif INVOICE_CAT eq 63>
		<cfset cash_acc_code= GET_NO_.ALINAN_F_F >
		<cfset DETAIL_=	"#getLang('main',399)#"><!--- ALINAN FIYAT FARKI FATURASI--->
	<cfelseif INVOICE_CAT eq 64>
		<cfset cash_acc_code= GET_NO_.M_MAKBUZU>
		<cfset DETAIL_=	"#getLang('main',411)#"><!---MÜSTAHSIL MAKBUZU --->
	<cfelseif INVOICE_CAT eq 65>
		<cfset cash_acc_code= GET_NO_.ALINAN_D_F>
		<cfset DETAIL_=	"#getLang('main',2615)#"><!---SABIT KIYMET ALIŞ MAKBUZU --->
	<cfelseif INVOICE_CAT eq 66>
		<cfset cash_acc_code= GET_NO_.VERILEN_D_F>
		<cfset DETAIL_=	"#getLang('main',2616)#"><!---SABIT KIYMET SATIŞ MAKBUZU --->
	<cfelseif INVOICE_CAT eq 591>
		<cfset cash_acc_code= GET_NO_.YURTDISI>
		<cfset DETAIL_=	"#getLang('main',408)#"><!---ITHALAT FATURASI --->
	<cfelseif INVOICE_CAT eq 531>
		<cfset DETAIL_=	"#getLang('main',409)#"><!---IHRACAT FATURASI --->
		<cfset cash_acc_code= GET_NO_.YURTDISI>
	<cfelseif INVOICE_CAT eq 532>
		<cfset DETAIL_=	"#getLang('main',1781)#"><!---KONSİNYE SATIŞ FATURASI --->
		<cfset cash_acc_code= ''>
	<cfelseif INVOICE_CAT eq 561>
		<cfset DETAIL_=	"#getLang('main',416)#"><!---VERILEN HAK EDİŞ FATURASI --->
		<cfset cash_acc_code= GET_NO_.TOPTAN_F_F >
	<cfelseif INVOICE_CAT eq 592>
		<cfset DETAIL_=	"#getLang('main',407)#"><!---HAL FATURASI --->
		<cfset cash_acc_code= GET_NO_.MAL_A_F >		
	<cfelseif INVOICE_CAT eq 601>
		<cfset cash_acc_code= GET_NO_.MAL_A_F >		
		<cfset DETAIL_= "#getLang('main',400)#"><!---ALINAN HAK EDİŞ FATURASI --->
	<cfelseif INVOICE_CAT eq 48>
		<cfset cash_acc_code= GET_NO_.TOPTAN_F_F >		
		<cfset DETAIL_= "#getLang('main',1775)#"><!--- VERİLEN KUR FARKI FATURASI--->
	<cfelseif INVOICE_CAT eq 49>
		<cfset cash_acc_code= GET_NO_.MAL_A_F >		
		<cfset DETAIL_= "#getLang('main',1776)#"><!---ALINAN KUR FARKI FATURASI --->
	<cfelseif INVOICE_CAT eq 69>
		<cfset cash_acc_code= GET_NO_.TOPTAN_F_F >		
		<cfset DETAIL_= "#getLang('main',1026)#"><!---Z RAPORU --->
    <cfelseif INVOICE_CAT eq 533>
		<cfset cash_acc_code= GET_NO_.TOPTAN_F_F >	
		<cfset DETAIL_= "#getLang('main',2617)#"><!---KDV DEN MUAF SATIŞ FATURASI --->
	<cfelseif INVOICE_CAT eq 5311>
		<cfset cash_acc_code= GET_NO_.IHRAC_K_F >	
		<cfset DETAIL_= "#getLang(dictionary_id:60998)#"><!---IHRAÇ KAYITLI SATIŞ --->
	<cfelseif INVOICE_CAT eq 680>
		<cfset cash_acc_code= GET_NO_.VERILEN_H_F >
		<cfset DETAIL_=	"#getLang(dictionary_id:29577)#"><!--- SERBEST MESLEK MAKBUZU --->
	<cfelseif INVOICE_CAT eq 640>
		<cfset cash_acc_code= GET_NO_.VERILEN_H_F >
		<cfset DETAIL_=	"#getLang(dictionary_id:39195)#"><!--- MÜSTAHSİL MAKBUZU --->
	<cfelseif INVOICE_CAT eq 5312>
		<cfset cash_acc_code= GET_NO_.IHRAC_K_F >	
		<cfset DETAIL_= "#getLang(dictionary_id:60092)#"><!---Bavul Ticareti Satış --->
	</cfif>
<cfelse>
	<cfif INVOICE_CAT eq 50>
		<cfset DETAIL_=	"#getLang('main',415)#"><!---VERİLEN VADE FARKI FATURASI --->
	<cfelseif INVOICE_CAT eq 51>
		<cfset DETAIL_=	"#getLang('main',351)#"><!---ALINAN VADE FARKI FATURASI --->
	<cfelseif INVOICE_CAT eq 52>
		<cfset DETAIL_=	"#getLang('main',353)#"><!---PERAKENDE SATIŞ FATURASI --->
	<cfelseif INVOICE_CAT eq 53>
		<cfset DETAIL_= "#getLang('main',413)#"><!--- TOPTAN SATIŞ FATURASI--->
	<cfelseif INVOICE_CAT eq 54>
		<cfset DETAIL_=	"#getLang('main',412)#"><!--- PERAKENDE SATIS IADE FATURASI--->
	<cfelseif INVOICE_CAT eq 55>
		<cfset DETAIL_=	"#getLang('main',356)#"><!---TOPTAN SATIS IADE FATURASI --->
	<cfelseif INVOICE_CAT eq 56>
		<cfset DETAIL_=	"#getLang('main',417)#"><!---VERİLEN HIZMET FATURASI --->
	<cfelseif INVOICE_CAT eq 57>
		<cfset DETAIL_=	"#getLang('main',358)#"><!---VERİLEN PROFORMA FATURASI --->
	<cfelseif INVOICE_CAT eq 58>
		<cfset DETAIL_=	"#getLang('main',418)#"><!--- VERİLEN FIYAT FARKI FATURASI--->
	<cfelseif INVOICE_CAT eq 59>
		<cfset DETAIL_=	"#getLang('main',410)#"><!---MAL ALIM FATURASI --->
	<cfelseif INVOICE_CAT eq 60>
		<cfset DETAIL_=	"#getLang('main',401)#"><!--- ALINAN HIZMET FATURASI--->
	<cfelseif INVOICE_CAT eq 61>
		<cfset DETAIL_=	"#getLang('main',402)#"><!---ALINAN PROFORMA FATURASI --->
	<cfelseif INVOICE_CAT eq 62>
		<cfset DETAIL_=	"#getLang('main',403)#"><!---ALIM IADE FATURASI --->
	<cfelseif INVOICE_CAT eq 63>
		<cfset DETAIL_=	"#getLang('main',399)#"><!--- ALINAN FIYAT FARKI FATURASI--->
	<cfelseif INVOICE_CAT eq 64>
		<cfset DETAIL_=	"#getLang('main',411)#"><!---MÜSTAHSIL MAKBUZU --->
	<cfelseif INVOICE_CAT eq 65>
		<cfset DETAIL_=	"#getLang('main',2615)#"><!---SABIT KIYMET ALIŞ MAKBUZU --->
	<cfelseif INVOICE_CAT eq 66>
		<cfset DETAIL_=	"#getLang('main',2616)#"><!---SABIT KIYMET SATIŞ MAKBUZU --->
	<cfelseif INVOICE_CAT eq 531>
		<cfset DETAIL_=	"#getLang('main',409)#"><!---IHRACAT FATURASI --->
	<cfelseif INVOICE_CAT eq 532>
		<cfset DETAIL_=	"#getLang('main',1781)#"><!---KONSİNYE SATIŞ FATURASI --->
	<cfelseif INVOICE_CAT eq 561>
		<cfset DETAIL_=	"#getLang('main',416)#"><!---VERILEN HAK EDİŞ FATURASI --->
	<cfelseif INVOICE_CAT eq 591>
		<cfset DETAIL_=	"#getLang('main',408)#"><!---ITHALAT FATURASI --->
	<cfelseif INVOICE_CAT eq 592>
		<cfset DETAIL_=	"#getLang('main',407)#"><!---HAL FATURASI --->
	<cfelseif INVOICE_CAT eq 601>
		<cfset DETAIL_= "#getLang('main',400)#"><!---ALINAN HAK EDİŞ FATURASI --->
	<cfelseif INVOICE_CAT eq 48>
		<cfset DETAIL_= "#getLang('main',1775)#"><!---VERİLEN KUR FARKI FATURASI --->
	<cfelseif INVOICE_CAT eq 49>
		<cfset DETAIL_= "#getLang('main',1776)#"><!---ALINAN KUR FARKI FATURASI --->
	<cfelseif INVOICE_CAT eq 69>
		<cfset DETAIL_= "#getLang('main',1026)#"><!---Z RAPORU --->
    <cfelseif INVOICE_CAT eq 533>
		<cfset DETAIL_= "#getLang(dictionary_id:36834)#"><!---KDV DEN MUAF SATIŞ FATURASI --->
	<cfelseif INVOICE_CAT eq 5311>
		<cfset DETAIL_= "#getLang(dictionary_id:60998)#"><!---IHRAÇ kAYITLI SATIŞ--->
	<cfelseif INVOICE_CAT eq 680>
		<cfset DETAIL_=	"#getLang(dictionary_id:29577)#"><!--- SERBEST MESLEK MAKBUZU --->
	<cfelseif INVOICE_CAT eq 640>
		<cfset DETAIL_=	"#getLang(dictionary_id:39195)#"><!--- MÜSTAHSİL MAKBUZU --->
	<cfelseif INVOICE_CAT eq 5312>
		<cfset DETAIL_= "#getLang(dictionary_id:60092)#"><!---Bavul Ticareti Satış --->
	</cfif>
</cfif>
