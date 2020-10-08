import React, { useEffect } from "react";
import axios from "@utils/webRequests";

const Test = () => {

  // sends dummy request when components renders
  useEffect(() => {
    axios.get(`/api/test`)
      .then(console.log)
      .catch(console.log);
  },[])

  return (
    <div>
      Test component!
    </div>
  )
}


export default Test;