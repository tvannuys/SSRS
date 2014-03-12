
SELECT * FROM OPENQUERY(GSFL2K,'
SELECT distinct stord#, strel#, stcmt1 ,sttseq,stseq#
					FROM shtext st LEFT JOIN shline sl ON (sl.slco = st.stco
								AND sl.slloc = st.stloc
								AND sl.slord# = st.stord#
								AND sl.slinv# = st.stinv#)  
					WHERE st.sttseq = 1 AND st.stseq# = 0 
					')