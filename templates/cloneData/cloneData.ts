function cloneData(data: any): any {
    let clone: any;
    if (
        typeof data === "object" &&
        data !== null &&
        !(data instanceof Array) &&
        !(data instanceof Set) &&
        !(data instanceof Map)
    ) {
        clone = {};
        for (const key in data) {
            clone[key] = cloneData(data[key]);
        }
    } else if (data instanceof Array) {
        clone = data.map((item: any) => cloneData(item));
    } else if (data instanceof Set) {
        clone = new Set();
        const setValues = data.values();
        for (let i = 0; i < data.size; i++) {
            clone.add(setValues.next().value);
        }
    } else if (data instanceof Map) {
        clone = new Map();
        data.forEach((value, key) => {
            clone.set(key, value);
        });
    } else {
        clone = data;
    }

    return clone;
}
