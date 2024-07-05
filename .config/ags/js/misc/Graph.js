import Widget from "resource:///com/github/Aylur/ags/widget.js";
const { Gtk } = imports.gi;


const draw_borders = (cr, width, height, radius) => {
    cr.arc(radius, radius, radius, Math.PI, 3 * Math.PI / 2);
    cr.arc(width - radius, radius, radius, 3 * Math.PI / 2, 0);
    cr.arc(width - radius, height - radius, radius, 0, Math.PI / 2);
    cr.arc(radius, height - radius, radius, Math.PI / 2, Math.PI);

    cr.closePath();
    cr.clip();
};

const draw_background = (cr, width, height, bg, border) => {
    cr.setSourceRGBA(bg.red, bg.green, bg.blue, bg.alpha);
    cr.rectangle(0, 0, width, height);
    cr.fill();

    cr.setSourceRGBA(border.red, border.green, border.blue, border.alpha);
    cr.setLineWidth(1)

    for (let y = height / 10; y < height; y += height / 10) {
        cr.moveTo(0, y);
        cr.lineTo(width, y);
        cr.stroke();
    }

    for (let x = width / 10; x < width; x += width / 10) {
        cr.moveTo(x, 0);
        cr.lineTo(x, height);
        cr.stroke();
    }
};

const draw_line = (cr, fg, width, height, data, samples) => {
    const max = 100.0;

    cr.setSourceRGBA(fg.red, fg.green, fg.blue, fg.alpha);
    cr.setLineWidth(2);

    for (let j = samples; j >= 0; j--) {
        const x = width * j / samples;
        const y = height * (1.0 - data[j] / max);

        cr.lineTo(x, y);
        cr.stroke();

        cr.moveTo(x, y);
    }
};

const draw_fill = (cr, fg, width, height, data, samples) => {
    const max = 100.0;
    let x = 0;
    let y = 0;

    cr.setSourceRGBA(fg.red, fg.green, fg.blue, 0.25);
    cr.moveTo(width, height);

    for (let j = samples; j >= 0; j--) {
        y = height * (1.0 - data[j] / max);
        x = width * j / samples;

        cr.lineTo(x, y);
    }

    cr.lineTo(x, height);
    cr.closePath();
    cr.fill();
};

const draw = (self, cr, width, height, data) => {
    const context = self.get_style_context()
    const bg = context.get_property('background-color', Gtk.StateFlags.NORMAL);
    const border = context.get_property('border-color', Gtk.StateFlags.NORMAL);
    const fg = context.get_property('color', Gtk.StateFlags.NORMAL);
    const radius = context.get_property('border-radius', Gtk.StateFlags.NORMAL);

    draw_borders(cr, width, height, radius);
    draw_background(cr, width, height, bg, border);

    const samples = data.length - 1;
    if (samples <= 0) {
        return;
    }

    draw_line(cr, fg, width, height, data, samples);
    draw_fill(cr, fg, width, height, data, samples);
};

const GraphWidget = (width, height, value, history_count, class_name, legend = "") => {
    const data = [];

    return Widget.Box({
        class_name: "graph",
        vertical: true,
        spacing: 6,
        children: [
            Widget.Box({
                class_name: "graph-box",
                child: Widget.DrawingArea({
                    class_names: ["drawing-area", class_name],
                    widthRequest: width,
                    heightRequest: height,
                    drawFn: (self, cr, width, height) => {
                        draw(self, cr, width, height, data);
                    },
                    setup(self) {
                        self.hook(value, () => {
                            data.push(value.value);
                            if (data.length > history_count) {
                                data.shift();
                            }
                            self.queue_draw()
                        });
                    }
                }),
            }),
            Widget.Label(legend),
        ],
    });
}

export default GraphWidget;
