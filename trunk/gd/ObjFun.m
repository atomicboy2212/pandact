%objective function
  function  val = ObjFun(x,n,xart)
      X0 = reshape(x,n,n);
      val = sum(sum(sqrt([diff(X0,1,2) zeros(n,1)].^2 + [diff(X0,1,1); zeros(1,n)].^2 )));
      val = val + 10 * 0.125 * (x-xart)'*(x-xart);