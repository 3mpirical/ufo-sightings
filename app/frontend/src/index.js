import React from 'react';
import ReactDOM from 'react-dom';
import theme from "@styles/theme";
import App from '@components/application/App';
import { BrowserRouter } from "react-router-dom";
import { ThemeProvider } from "emotion-theming";
import '@styles/global.css';

ReactDOM.render(
  <React.StrictMode>
    <BrowserRouter>
      <ThemeProvider theme={theme}>
        <App />
      </ThemeProvider>
    </BrowserRouter>
  </React.StrictMode>,
  document.getElementById('root')
);
