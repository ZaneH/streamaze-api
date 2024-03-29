// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

import ApexCharts from "apexcharts";

let Hooks = {};
Hooks.LocalTime = {
    mounted() {
        this.updated();
    },
    updated() {
        let dt = new Date(this.el.textContent);
        let offset = dt.getTimezoneOffset();
        var localDt = new Date(dt.getTime() - offset * 60 * 1000);
        this.el.textContent = localDt.toLocaleString();
    },
};

Hooks.ApexChart = {
    mounted() {
        this.updated();
    },
    updated() {
        const xAxisAttr = this.el.getAttribute("xaxis");
        const yAxisAttr = this.el.getAttribute("yaxis");
        let xAxis;
        let yAxis;

        try {
            xAxis = JSON.parse(xAxisAttr);
            xAxis = xAxis.map((x) => {
                date = new Date(parseInt(x));
                return date.toLocaleString();
            });

            yAxis = JSON.parse(yAxisAttr);
        } catch (e) {
            console.error(e);
        }

        // ApexCharts options and config
        let options = {
            dataLabels: {
                enabled: true,
                // offsetX: 10,
                style: {
                    cssClass: "text-xs text-white font-medium",
                },
            },
            grid: {
                show: false,
                strokeDashArray: 4,
                padding: {
                    left: 16,
                    right: 16,
                    top: -26,
                },
            },
            series: [
                {
                    name: "Chat messages",
                    data: yAxis,
                    color: "#1A56DB",
                },
            ],
            chart: {
                height: "100%",
                maxWidth: "100%",
                type: "area",
                fontFamily: "Inter, sans-serif",
                dropShadow: {
                    enabled: false,
                },
                toolbar: {
                    show: false,
                },
            },
            tooltip: {
                theme: "dark",
                enabled: true,
                x: {
                    show: false,
                },
            },
            legend: {
                show: true,
            },
            fill: {
                type: "gradient",
                gradient: {
                    opacityFrom: 0.55,
                    opacityTo: 0,
                    shade: "#1C64F2",
                    gradientToColors: ["#1C64F2"],
                },
            },
            stroke: {
                width: 6,
            },
            xaxis: {
                categories: xAxis,
                labels: {
                    show: false,
                },
                axisBorder: {
                    show: false,
                },
                axisTicks: {
                    show: false,
                },
            },
            yaxis: {
                show: false,
                labels: {
                    formatter: function (value) {
                        return value;
                    },
                },
            },
        };

        if (this.el) {
            const chart = new ApexCharts(this.el, options);

            chart.render();
        }
    },
};

import "flowbite/dist/flowbite.phoenix.js";

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let csrfToken = document
    .querySelector("meta[name='csrf-token']")
    .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
    params: { _csrf_token: csrfToken },
    hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
