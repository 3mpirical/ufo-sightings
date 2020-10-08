import React from 'react';
import Test from "@components/Test";
import { Switch, Route } from "react-router-dom";
import NoMatch from "@components/auth/NoMatch";

function App() {
  return (
    <div className="App">
      <Switch>
        <Route exact path="/">
          <Test />
        </Route>
        <Route path="*">
          <NoMatch />
        </Route>
      </Switch>
    </div>
  );
}

export default App;
