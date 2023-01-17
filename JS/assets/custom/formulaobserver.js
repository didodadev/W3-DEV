function registerGlobalFormulas(data) {
    data.sum = function(list) {
        if (list.length === 0) return 0;
        return parseFloat(parseFloat( list.reduce(function(a, v) { 
            var convertedv = v.replace(",", ".");
            var converteda = a != undefined ? 0 : a;
            converteda = a.toString().replace(",", ".");
            var itemvalue = (convertedv == "" || isNaN(convertedv) ? 0 : parseFloat(convertedv));
            if (data.floatsize != undefined && data.floatsize != null)
            {
                itemvalue = parseFloat(parseFloat(Math.round(itemvalue + 'e+' + data.floatsize)) + 'e-' + data.floatsize);
            }
            return parseFloat(converteda) + parseFloat(itemvalue);
        }
        )+'e+'+data.floatsize )+'e-'+data.floatsize).toString().replace('.', ',');
    }
}

var formulaObserver = function() {
    var self = this;
    self.observers = {};

    return {
        add: function(struct, observable) {
            if (self.observers[struct] === undefined)
            {
                self.observers[struct] = observable;
            }
        },
        get: function(struct) {
            return self.observers[struct];
        }
    }
}();

var formulaObservable = function(container) {

    var self = this;
    self.container = container;
    self.formulas = [];

    // initialize objects

    self.bind = function() {
        self.formulas = [];
        var formulaElements = $(self.container).find("input[data-clientformula], select[data-clientformula], textarea[data-clientformula]");
        formulaElements.each(function(idx, element) {
            var formula = new Formula($(element).data("clientformula"));
            var formulaData = {
                element: $(element).attr("name"),
                formula: formula,
                floatsize: $(element).data("floatsize"),
                type: $(element).closest('[data-formulasummary="true"]').length === 0 ? 'simple' : 'array'
            };
            if (self.formulas.find(elm => elm.element == $(element).attr("name")) === undefined)
            {
                self.formulas.push(formulaData);
            }
        });

        var rowforulaElements = $(self.container).find("tr[data-rowformula]");
        rowforulaElements.each(function(idx, element) {
            var formula = new Formula($(element).data("rowformula"));
            var formulaData = {
                element: $(element).data("refname"),
                formula: formula,
                floatsize: $(element).data("floatsize"),
                type: 'groupby'
            };
            if (self.formulas.find(elm => elm.element == $(element).data("refname")) === undefined)
            {
                self.formulas.push(formulaData);
            }
        });
    }

    // notify
    self.notify = function() {

        self.formulas.forEach(function(formula) {
            if (formula.type == 'groupby')
            {
                $('tr[data-dynamic="' + formula.element + '"]').remove();
                var groupby = $('tr[data-refname="' + formula.element + '"]').data("rowformulagroupby");
                var groups = [];
                $('tr[data-refname="' + formula.element + '"]').closest("[data-formulacontainer]").find('[data-name="' + groupby + '"]').each(function(idx, mapped) {
                    if ($(mapped).val() != "")
                        groups.push({ group: $(mapped).val(), index: $(mapped).closest("tr").data("rowindex") });
                });
                var variable = formula.formula.getVariables()[0];
                var evaluatedGroups = [];
                groups.forEach(function(val) {
                    if (evaluatedGroups.indexOf(val.group) == -1) {
                        evaluatedGroups.push(val.group);
                        var groupVariable = [];
                        $('tr[data-refname="' + formula.element + '"]').closest("[data-formulacontainer]").find('[data-name="' + variable + '"]').each(function(idx, elm) {
                            var groupItem = groups.find(function(groupelm) {
                                return groupelm.index == $(elm).closest("tr").data("rowindex");
                            });
                            if (groupItem !== undefined && groupItem.group == val.group)
                            {
                                groupVariable.push($(elm).val());
                            }
                        });

                        var data = {};
                        data[variable] = groupVariable;
                        registerGlobalFormulas(data);
                        try {
                        $('tr[data-refname="' + formula.element + '"]').after('<tr data-dynamic="' + formula.element + '"><td>' + $('tr[data-refname="' + formula.element + '"]').data("elementlabel") + val.group + '</td><td><input value="' + formula.formula.evaluate(data) + '"></td></tr>');
                        } catch (error) {
                            console.error( ["formulaError", error] );
                        }
                    }
                });
            }
            else
            {
                var data = {};
                $(self.container).find("input, select, textarea").each(function(idx, elm) {
                    if (formula.type == 'simple')
                    {
                        if ($(elm).closest('[data-formulasummary="false"]').length == 0)
                        {
                            if ($(elm).data("name") === undefined) {
                                data[$(elm).attr("name")] = $(elm).val().replace(',', '.');
                            } else {
                                data[$(elm).data("name")] = $(elm).val().replace(',', '.');
                            }
                        } else if ($(elm).closest("tr").data("rowindex") == $('[name="' + formula.element + '"]').closest("tr").data("rowindex")) {
                            if ($(elm).data("name") === undefined) {
                                data[$(elm).attr("name")] = $(elm).val().replace(',', '.');
                            } else {
                                data[$(elm).data("name")] = $(elm).val().replace(',', '.');
                            }
                        }
                    } else if (formula.type == 'array') {
                        data[$(elm).data("name")] = $(elm).closest("[data-formulacontainer]").find('[data-name="' + $(elm).data("name") + '"]').map(function(idx, mapped) {
                            return $(mapped).val();
                        }).get();
                    }
                });
            
                registerGlobalFormulas(data);
                try {
                    var calculated = formula.formula.evaluate(data);
                    if (formula.floatsize != undefined && formula.floatsize != null) {
                        calculated = parseFloat(parseFloat(Math.round(calculated + 'e+' + formula.floatsize)) + 'e-' + formula.floatsize).toString().replace('.',',');
                    }
                    $("[name='" + formula.element + "']").val( calculated );
                } catch (error) {
                    console.error( ["formulaError", error] );
                }
            }
        });
    }

    // rebind
    self.rebind = function() {
        self.bind();
        self.notify();
        $(self.container).find("input, select, textarea").change(function() {
            self.notify();
        });
    }

    self.bind();
    if (self.formulas.length == 0) return;
    $(self.container).find("input, select, textarea").change(function() {
        self.notify();
    });

    window.formulaNotify = self.notify;
}

$( document ).ready( function() {
    $( "[data-formulacontainer]" ).each( function( idx, container ) {
        formulaObserver.add( $( container ).data( "formulacontainer" ), new formulaObservable( '[data-formulacontainer="' + $(container).data( "formulacontainer" ) + '"]' ) );
    });
    window.formulaNotify();
});