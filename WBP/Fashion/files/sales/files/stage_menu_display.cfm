<script>
var stageid = "170";
var menutext = "Sarf Fişi Dönüştür";
</script>

<script>
    $(document).ready(function() {

        if ($("#process_stage").val() != stageid) 
        {
            $("#tabMenu a:contains('"+ menutext +"')").hide();
        }
        $("#process_stage").change(function() { 
            if ($(this).val() != stageid) { 
                $("#tabMenu a:contains('"+ menutext +"')").hide(); 
            } else { 
                $("#tabMenu a:contains('"+ menutext +"')").show();
            } 
        });
    });
</script>