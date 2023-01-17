//custom handlers
ko.bindingHandlers.readonly = {
    init: function (element, valueAccessor) {
        if (valueAccessor()) {
            element.setAttribute("readonly", "readonly");
        } else {
            element.removeAttribute("readonly");
        }
    }
};
ko.bindingHandlers.numeric = {
    init: function (element, valueAccessor) {
        if (valueAccessor()) {
            element.style.textAlign = "right";
        }
    }
}
ko.bindingHandlers.required = {
    init: function (element, valueAccessor) {
        if (valueAccessor()) {
            element.setAttribute("required", "required");
        } else {
            element.removeAttribute("required");
        }
    }
}

ko.bindingHandlers.tlValue = {
    init: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
        let value = valueAccessor();
        element.style.textAlign = "right";
        element.addEventListener("blur", () => {
            value( parseFloat( filterNum( isNaN(element.value.replace(".","").replace(",",".")) || element.value == '' ? "0" : element.value, basketService.priceRoundNumber() ) ) );
        })
    },
    update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
        let value = valueAccessor();
        element.value = commaSplit( value(), basketService.priceRoundNumber() );
    }
};
ko.bindingHandlers.basketFormula = {
    init: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
        element.addEventListener("blur", () => {
            valueAccessor()();
        })
    }
}
ko.bindingHandlers.basketValue = {
    init: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
        let value = valueAccessor();
        if (value === undefined || ko.isComputed(value)) return;
        let index = bindingContext.$index();
        element.addEventListener("blur", () => {
            if (bindingContext.$root.basketHeadersForVisible()[index].isNumeric)
                value( parseFloat( filterNum( isNaN(element.value.replace(".","").replace(",",".")) || element.value == '' ? "0" : element.value, basketService.priceRoundNumber() ) ) );
            else
                value( element.value );
            if (bindingContext.$root.basketHeadersForVisible()[index].isHesapla)
                basketService.basketRowCalculate()( bindingContext.$root.basketHeadersForVisible()[index].id, bindingContext.$root.basketItems()[bindingContext.$root.activeRowIndex()] );
            
        });
        if (bindingContext.$root.activeColIndex() == bindingContext.$index()) {
            element.focus();
        }
    },
    update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
        let value = valueAccessor();
        if (value === undefined) return;
        let index = bindingContext.$index();
        if (bindingContext.$root.basketHeadersForVisible()[index].isNumeric) {
            element.value = commaSplit( value(), basketService.priceRoundNumber() );
        } else {
            element.value = value();
        }
        
    }
};
ko.bindingHandlers.basketElement = {
    update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
        let value = valueAccessor();
        if (value === undefined) return;
        let index = bindingContext.$index();
        if (bindingContext.$root.basketHeadersForVisible()[index].isNumeric) {
            element.innerHTML = commaSplit( value(), basketService.priceRoundNumber() );
        } else {
            element.innerHTML = value();
        }
    }
};
ko.bindingHandlers.basketFooterTotalElement = {
    update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
        let value = valueAccessor();
        if (value === undefined) return;
        element.innerHTML = commaSplit( typeof value == "function" ? value() : value, basketService.basketTotalRoundNumber());
    }
}