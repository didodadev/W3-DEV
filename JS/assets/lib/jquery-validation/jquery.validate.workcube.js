jQuery.validator.addMethod("wcdate", function(value, element, option) {
    var euroFormat = /^(3[01]|[12][0-9]|0?[1-9])\/(1[012]|0?[1-9])\/((?:19|20)\d{2})$/;
    var usaFormat = /^(1[012]|0?[1-9])\/(3[01]|[12][0-9]|0?[1-9])\/((?:19|20)\d{2})$/;
    var formatter = option === "mm/dd/yyyy" ? usaFormat : euroFormat;
    return this.optional(element) || formatter.test(value);
}, $.validator.messages.date);
