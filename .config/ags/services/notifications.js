import Service from "resource:///com/github/Aylur/ags/service.js";
import { execAsync, interval } from "resource:///com/github/Aylur/ags/utils.js";

class NotificationsService extends Service {
    static {
        Service.register(
            this,
            {},
            {
                count: ["int", "rw"],
                dnd: ["boolean", "rw"],
            },
        );
    }

    _count = 0;
    _dnd = false;

    get count() {
        return this._count;
    }

    get dnd() {
        return this._dnd;
    }

    _getCount() {
        execAsync("swaync-client --count").then(n => {
            this.updateProperty("count", n);
        });

        execAsync("swaync-client --get-dnd").then(dnd => {
            this.updateProperty("dnd", dnd == "true");
        });
    }

    constructor() {
        super();
        interval(1000 * 2, this._getCount.bind(this)); // every 2 seconds
    }
}

export default new NotificationsService();
