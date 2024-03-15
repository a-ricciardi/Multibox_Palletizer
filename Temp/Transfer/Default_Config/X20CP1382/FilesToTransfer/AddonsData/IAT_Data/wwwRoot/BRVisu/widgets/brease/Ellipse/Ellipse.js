define([
    'widgets/brease/Rectangle/Rectangle',
    'brease/enum/Enum',
    'brease/core/Types'
], function (SuperClass, Enum, Types) {

    'use strict';

    /**
     * @class widgets.brease.Ellipse
     * #Description
     * Widget for displaying an ellipsis
     * @breaseNote 
     * @extends widgets.brease.Rectangle
     *
     * @iatMeta category:Category
     * Drawing
     * @iatMeta description:short
     * Grafikobjekt
     * @iatMeta description:de
     * Zeichnet eine Ellipse
     * @iatMeta description:en
     * Draws an ellipsis
     */

    /**
     * @htmltag examples
     * ##Configuration examples:  
     *
     *     <div id="Ellipse01" data-brease-widget="widgets/brease/Ellipse" data-brease-options="{'width':200, 'height':100}"></div>
     *
     */

    var defaultSettings = {},

        WidgetClass = SuperClass.extend(function Ellipse() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {
        if (this.settings.omitClass !== true) {
            this.addInitialClass('breaseEllipse');
        }
       
        SuperClass.prototype.init.call(this);

    };

    return WidgetClass;

});
