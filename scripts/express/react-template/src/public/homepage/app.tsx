import React from "react";
import { useState } from "react";

export default function App() {
    const colors: string[] = ["salmon", "green", "lightcoral", "lightblue"];
    const [colorIdx, setColorIdx] = useState<number>(0);

    function handleClick(): void {
        if (colorIdx >= colors.length - 1) {
            return setColorIdx(0);
        }
        setColorIdx(colorIdx + 1);
    }

    return (
        <div
            id="app"
            style={{
                backgroundColor: `${colors[colorIdx]}`,
            }}
        >
            <p>Hello World</p>
            <button onClick={handleClick}>Click Me</button>
        </div>
    );
}
