var gridUpdater = function() {
    var self = this;
    
    self.update = function(source, target, event) {
        switch (event) {
            case 'table':
                this.updateTable(source, target);
                break;
            case "row":
                this.updateRow(source, target);
                break;
            case "field":
                this.updateElement(source, target);
                break;
        }
    }

    self.updateTable = function(source, target) {
        var rows = $(source).children("tr");
        rows.forEach(row => {
            if ($(row).find('input[data-rowselector="true"]').checked())
                self.updateRow(row, target);
        });
    }

    self.updateRow = function(source, target) {
        var data = {};

        var fields = $(source).children("input, select, textarea");
        if (fields.length > 0) {
            data.keyfield = $(fields[0]).data("keyfield");
            data.keyvalue = $(fields[0]).data("keyvalue");

            fields.forEach(elm => {
                if ($(elm).tagName == "INPUT" && $(elm).type == "radio")
                {
                    if ($(elm).checked())
                        data[$(elm).data("name")] = $(elm).val();
                }
                else if ($(elm).tagName == "INPUT" && $(elm).type == "checkbox")
                {
                    data[$(elm).data("name")] = $(elm).checked() ? 1 : 0;
                }
                else
                {
                    data[$(elm).data("name")] = $(elm).val();
                }
            });
            self.postData(data, target);
        }
    }

    self.updateElement = function (source, target) {
        var data = {};
        data.keyfield = $(source).data("keyfield");
        data.keyvalue = $(source).data("keyvalue");
        if ($(source).tagName == "INPUT" && $(source).type == "radio")
        {
            if ($(source).checked())
                data[$(source).data("name")] = $(source).val();
        }
        else if ($(source).tagName == "INPUT" && $(source).type == "checkbox")
        {
            data[$(source).data("name")] = $(source).checked() ? 1 : 0;
        }
        else
        {
            data[$(source).data("name")] = $(source).val();
        }
        self.postData(data, target);
    }

    self.postData = function(data, target) {
        $.ajax({
            url: window.gridUpdateUrl() + "&partial=" + target,
            data: data,
            method: "POST",
            success: function(result) {}
        });
    }

    return {
        update: function(source, target, event) {
            self.update(source, target, event);
        }
    }
}();