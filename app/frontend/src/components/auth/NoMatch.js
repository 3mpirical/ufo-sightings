import React from 'react';
import { Link } from 'react-router-dom';
import MessagePage from '@elements/MessagePage';

const NoMatch = () => (
  <MessagePage title="(404) Page Does Not Exist">
    You may go to the previous page in your browser, or click
    &nbsp;
    <Link to="/">here</Link>
    &nbsp;
    to go home.
  </MessagePage>
);

export default NoMatch;
