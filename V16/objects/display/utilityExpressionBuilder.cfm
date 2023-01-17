
<div class="row">
    <div class="col col-12">
        <div class="form-group">
            <input type="text" id="expression-input" style="padding-left: 30px; height: 35px;">
        </div>
    </div>
</div>
<script type="text/javascript">
$(document).ready(function() {
    window.expinput = $("#expression-input").expressionBuilder(
        { variables: window.opener.getFieldList().map( function(elm) { return { variableId: elm.label, name: elm.label }; }) }
    );
});
</script>