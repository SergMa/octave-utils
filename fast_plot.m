%Fast version of plot() in Octave
%For big input data arrays this function works much faster
%than existing plot() in Octave. fast_plot() internally
%reduces sizes of input arrays to increase speed of plotting.
%
%INPUTS:  x = MxN or NxM array of x-coordinates
%         y = MxN or NxM array of y-coordinates
%         p = data points and lines style string
%OUTPUTS: h = pointer to created plot
%
%EXAMPLES: fast_plot(x);
%          fast_plot(x,y);
%          fast_plot(x,'r.-');
%          fast_plot(x1,y1,'r.-',x2,y2,'gx-');
%          Any input arguments set of standard plot() function
%          may be used with fast_plot().
function h = fast_plot(varargin)
    
    prevhold = ishold;
    hold on;
    
    NMAX = 10000; %Number of points in reduced arrays, must be even!
    
    sargs = varargin;
    
    %Parse arguments
    for ai=1:nargin
        %If needed, reduce heights of arrays
        if isnumeric(varargin{ai})
            iarr = varargin{ai};
            N = size(iarr,1);
            M = size(iarr,2);
            if (N==1) && (M>1)
                %convert array-row to array-column
                N = M;
                M = 1;
                iarr = iarr.';
            end
            
            if N>NMAX
                sargs{ai} = zeros(NMAX,M);
                jj = 1;
                dj = 2*N/NMAX;
                
                for i=1:2:NMAX
                    jb = round(jj);
                    if jb>N
                        jb=N;
                    end
                    jj = jj + dj;
                    je = round(jj);
                    if je>N
                        je=N;
                    end
                    
                    [xmin,idxmin] = min( iarr(jb:je,:),[],1 );
                    [xmax,idxmax] = max( iarr(jb:je,:),[],1 );

                    %xmin
                    %idxmin
                    %xmax
                    %idxmax
                    
                    for p=1:length(xmin)
                        if idxmin(p)<idxmax(p)
                            sargs{ai}(i  ,p) = xmin(p);
                            sargs{ai}(i+1,p) = xmax(p);
                        else
                            sargs{ai}(i  ,p) = xmax(p);
                            sargs{ai}(i+1,p) = xmin(p);
                        end
                    end
                end
            end
        end
    end

    %Plot reduced array
    ai = 1;
    while ai<=nargin
        x=[];
        y=[];
        p=[];
        if ai<=nargin && isnumeric( sargs{ai} )
            x = sargs{ai};
            ai = ai + 1;
        end
        if ai<=nargin && isnumeric( sargs{ai} )
            y = sargs{ai};
            ai = ai + 1;
        end
        if ai<=nargin && ischar( sargs{ai} )
            p = sargs{ai};
            ai = ai + 1;
        end
        
        if     (~isempty(x)) && (~isempty(y)) && (~isempty(p))
            h = plot(x,y,p);    
        elseif (~isempty(x)) && (~isempty(y)) && (isempty(p))
            h = plot(x,y);
        elseif (~isempty(x)) && (isempty(y)) && (~isempty(p))
            h = plot(x,p);
        elseif (~isempty(x))
            h = plot(x);
        else
            error('invalid arguments');
        end
    end
    
    if prevhold
        hold on;
    else
        hold off;
    end
    
return
