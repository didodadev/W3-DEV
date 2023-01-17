
<!---
    Author: Workcube - Gülbahar Inan <gulbaharinan@workcube.com>
    Date: 19.08.2020
    Description:
	Seyahat Talebi Formu Birim Onayı (display file) sonra butonları pasife çeker.
--->
<script type="text/javascript">
    function process_cat_dsp_function()
    {   
        var action_id_ = document.travel_demand.travel_demand_id.value;
        var get_travel_demand_ = wrk_safe_query('travel_demand_unit','dsn',0,action_id_);
        if (get_travel_demand_.recordcount != 0) {
            $(':input').attr('readonly','readonly');
            $(':radio').attr('disabled', true);
            $(':checkbox').attr('disabled', true);
            $('.empty').attr('disabled',true);
            $("span").css("pointer-events", "none");
            $("#wrk_delete_button").attr("disabled", true);
        }
    }
</script>
    
