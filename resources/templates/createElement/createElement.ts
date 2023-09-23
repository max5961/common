interface EVL {
    [key: string]: EventListener;
}

interface Attributes {
    [key: string]: string | EVL;
}

export function createElement(type: string, attributes: Attributes = {}, ...children: Array<HTMLElement>): HTMLElement {
    const element: HTMLElement = document.createElement(type);

    for (const key in attributes) {
        if (key === 'class') {
            const userClasses: string[] = (attributes.class as string).split(" ");
            element.classList.add(...userClasses);
        }

        else if (key === 'evl' && typeof attributes.evl === 'object') {
            for (const eventKey in attributes.evl) {
                element.addEventListener(eventKey, attributes.evl[eventKey] as EventListener);
            }
        }

        else if (key === 'tc') {
            element.textContent = attributes[key] as string;
        }

        else {
            element.setAttribute(key, attributes[key] as string);
        }
    }

    for (const child of children) {
        element.appendChild(child);
    }

    return element;
}

// example
function buildHeader() {
    return  (
        createElement(
            'div', {class: "header default"},
            createElement(
                'p', {class: 'hello-world', tc: 'hello world'}
            ),
            createElement(
                'span', {tc:' hello world'}
            )
        )
    );
}


function buildHeader2() {
    return  (
        createElement(
            'div', {class: "header default"},
            createElement(
                'p', {class: 'hello-world', tc: 'hello world'}
            ),
            createElement(
                'span', {tc:' hello world'}
            )
        )
    );
}

