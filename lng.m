function xnew=lng(f,x,tol,varargin)
    xnew=f(x,varargin{:});
    while sum((xnew-x).^2)>tol
        x=xnew;
        xnew=f(x,varargin{:});
    end
    
