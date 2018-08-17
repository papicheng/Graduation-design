function mywaitbar(x,varargin)
if nargin < 1
    error('Input arguments not valid');
end
fh = varargin{end};
set(0,'CurrentFigure',fh);
fAxes = findobj(fh,'type','axes');
set(fh,'CurrentAxes',fAxes);
if nargin > 1
    hTitle = get(fAxes,'title');
    set(hTitle,'String',varargin{1});
end
fractioninput = x;
x = max(0,min(100*x,100));
if fractioninput == 0    
    cla
    xpatch = [0 x x 0];
    ypatch = [0 0 1 1];
    xline = [100 0 0 100 100];
    yline = [0 0 1 1 0];
    patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','none');
    set(fh,'UserData',fractioninput);
    l = line(xline,yline,'EraseMode','none');
    set(l,'Color',get(gca,'XColor'));   
else
    p = findobj(fh,'Type','patch');
    l = findobj(fh,'Type','line');
    if (get(fh,'UserData') > fractioninput)
        set(p,'EraseMode','normal');
    end
    xpatch = [0 x x 0];
    set(p,'XData',xpatch);
    xline = get(l,'XData');
    set(l,'XData',xline);  
end
drawnow;
