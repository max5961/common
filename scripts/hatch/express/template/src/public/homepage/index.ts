import "./style/index.scss";
import logo from "./images/apiary.svg";

const sq = document.querySelector(".box") as HTMLDivElement;
const img = document.createElement("img") as HTMLImageElement;

img.src = logo;

sq.appendChild(img);

console.log("Hello world from public/homepage/index.ts");
