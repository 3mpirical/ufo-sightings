import React from 'react';
/** @jsx jsx */
import { jsx, css } from '@emotion/core';
import styled from '@emotion/styled';

const MessagePage = ({ title, TitleProps, children }) => (
  <Container>
    <Title {...TitleProps}>{title}</Title>
    <Message>{children}</Message>
  </Container>
);

const Container = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
`;

const Title = styled.h1`
  color: grey;
  font-size: 4rem;
  padding: 5rem;
`;

const Message = styled.div`
  color: grey;
  font-size: 1rem;
`;

export default MessagePage;
