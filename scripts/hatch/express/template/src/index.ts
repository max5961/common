import app from "./server";

/* 0 as an argument tells Express to choose an open port */
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
