import Service from "resource:///com/github/Aylur/ags/service.js";
import { execAsync, interval } from "resource:///com/github/Aylur/ags/utils.js";

class NotificationsService extends Service {
    static {
        Service.register(
            this,
            {},
            {
                count: ["int", "rw"],
            },
        );
    }

    _count = 0;

    get count() {
        return this._count;
    }

    _getCount() {
        execAsync("swaync-client --count").then(n => {
            this.updateProperty("count", n);
        });
    }

    constructor() {
        super();
        interval(1000 * 2, this._getCount.bind(this)); // every 2 seconds
    }
}

export default new NotificationsService();
