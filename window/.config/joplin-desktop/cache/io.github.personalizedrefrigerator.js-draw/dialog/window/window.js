/*
 * ATTENTION: The "eval" devtool has been used (maybe by default in mode: "development").
 * This devtool is neither made for production nor for readable output files.
 * It uses "eval()" calls to create a separate source file in the browser devtools.
 * If you are trying to read the output file, select a different devtool (https://webpack.js.org/configuration/devtool/)
 * or disable the default devtool with "devtool: false".
 * If you are looking for production-ready output files, see mode: "production" (https://webpack.js.org/configuration/mode/).
 */
/******/ (() => { // webpackBootstrap
/******/ 	"use strict";
/******/ 	var __webpack_modules__ = ({

/***/ "./src/dialog/window/window.ts":
/*!*************************************!*\
  !*** ./src/dialog/window/window.ts ***!
  \*************************************/
/***/ ((__unused_webpack_module, exports) => {

eval("\nObject.defineProperty(exports, \"__esModule\", ({ value: true }));\nconst log = (message) => {\n    const container = document.createElement('p');\n    container.appendChild(document.createTextNode(message));\n    container.onclick = () => container.remove();\n    const logArea = document.querySelector('#log-container');\n    logArea === null || logArea === void 0 ? void 0 : logArea.appendChild(container);\n};\nlet pluginMessageListeners = [];\nwindow.onmessage = (event) => {\n    var _a;\n    if (!event.origin.startsWith('file:')) {\n        log(`Ignored message with origin ${event.origin}`);\n        return;\n    }\n    const data = event.data;\n    if (data.kind === 'addScript') {\n        const src = event.data.src;\n        if (src.endsWith('.js')) {\n            const scriptElement = document.createElement('script');\n            scriptElement.src = src;\n            document.head.appendChild(scriptElement);\n        }\n        else {\n            const linkElement = document.createElement('link');\n            linkElement.href = src;\n            linkElement.rel = 'stylesheet';\n            document.head.appendChild(linkElement);\n        }\n    }\n    else if (data.kind === 'setButtons') {\n        const buttons = data.buttons;\n        const buttonElements = [];\n        for (const buttonRecord of buttons) {\n            const buttonElement = document.createElement('button');\n            buttonElement.innerText = (_a = buttonRecord.title) !== null && _a !== void 0 ? _a : buttonRecord.id;\n            buttonElement.onclick = () => {\n                window.parent.postMessage({\n                    kind: 'dialogResult',\n                    result: { id: buttonRecord.id },\n                }, '*');\n                window.close();\n            };\n            buttonElements.push(buttonElement);\n        }\n        // Replace the button container\n        let buttonContainer = document.querySelector('.button-container');\n        if (buttonContainer)\n            buttonContainer.remove();\n        buttonContainer = document.createElement('div');\n        buttonContainer.classList.add('button-container');\n        buttonContainer.replaceChildren(...buttonElements);\n        document.body.appendChild(buttonContainer);\n    }\n    else {\n        pluginMessageListeners.forEach((l) => l(event));\n    }\n};\nwindow.addEventListener('error', (e) => {\n    log(e.toString() + e.error.stack);\n});\n// Emulate Joplin's webviewApi for compatibility\nwindow.webviewApi = {\n    postMessage: (message) => {\n        const id = Math.random();\n        window.parent.postMessage({\n            message,\n            id,\n        }, '*');\n        return new Promise((resolve) => {\n            const responseListener = (event) => {\n                if (event.data.responseId === id) {\n                    pluginMessageListeners = pluginMessageListeners.filter((l) => l !== responseListener);\n                    resolve(event.data.response);\n                }\n            };\n            pluginMessageListeners.push(responseListener);\n        });\n    },\n    onMessage: (listener) => {\n        pluginMessageListeners.push((event) => {\n            if (event.data.message) {\n                listener(event.data);\n            }\n        });\n    },\n};\n\n\n//# sourceURL=webpack://default/./src/dialog/window/window.ts?");

/***/ })

/******/ 	});
/************************************************************************/
/******/ 	
/******/ 	// startup
/******/ 	// Load entry module and return exports
/******/ 	// This entry module can't be inlined because the eval devtool is used.
/******/ 	var __webpack_exports__ = {};
/******/ 	__webpack_modules__["./src/dialog/window/window.ts"](0, __webpack_exports__);
/******/ 	exports["default"] = __webpack_exports__["default"];
/******/ 	
/******/ })()
;