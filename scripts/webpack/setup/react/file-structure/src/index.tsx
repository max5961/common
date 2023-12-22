import "./style/index.scss";
import React from "react";
import ReactDOM from "react-dom";
import App from "./app";

const root: HTMLElement | null = document.getElementById("root");
if (root) {
    root.style.height = "100vh";
    root.style.width = "100vw";
}

ReactDOM.render(<App />, root);
