Attribute VB_Name = "Module1"
Option Explicit

Sub StockSummary()
    Dim ws As Worksheet
    Dim row As Long
    Dim TickerName As String
    Dim TickerCounter As Integer
    Dim TickerTotal As Double
    Dim StartTicker As Double
    Dim EndTicker As Double
    Dim TickerChange As Double
    Dim TickerPercentChange As Double
    Dim LastRow As Double
    Dim LastTickerRow As Double
    Dim MaxTotal As Double
    Dim MaxDecrease As Double
    Dim MaxIncrease As Double
    Dim MaxDecreaseName As String
    Dim MaxIncreaseName As String
    Dim MaxTotalName As String
    
    For Each ws In Worksheets
        LastRow = ws.Cells(Rows.Count, 1).End(xlUp).row
        TickerCounter = 2
        StartTicker = ws.Cells(2, 3).Value
        
        If ws.Range("I1").Value <> "Ticker" Then
            ws.Range("I1").EntireColumn.Insert
            ws.Range("I1").Value = "Ticker"
            ws.Range("J1").EntireColumn.Insert
            ws.Range("J1").Value = "Quarterly Change ($)"
            ws.Range("K1").EntireColumn.Insert
            ws.Range("K1").Value = "Percent Change"
            ws.Range("L1").EntireColumn.Insert
            ws.Range("L1").Value = "Total Stock Volume"
        End If
        
        For row = 2 To LastRow
            If ws.Cells(row + 1, 1).Value <> ws.Cells(row, 1).Value Then
                TickerName = ws.Cells(row, 1).Value
                TickerTotal = TickerTotal + ws.Cells(row, 7).Value
                EndTicker = ws.Cells(row, 6).Value
                TickerChange = EndTicker - StartTicker
                TickerPercentChange = (TickerChange / StartTicker)
                
                ws.Cells(TickerCounter, 9).Value = TickerName
                ws.Cells(TickerCounter, 10).Value = TickerChange
                ws.Cells(TickerCounter, 11).Value = TickerPercentChange
                ws.Cells(TickerCounter, 12).Value = TickerTotal
                
                If ws.Cells(TickerCounter, 10).Value < 0 Then
                    ws.Cells(TickerCounter, 10).Interior.ColorIndex = 3
                ElseIf ws.Cells(TickerCounter, 10).Value > 0 Then
                    ws.Cells(TickerCounter, 10).Interior.ColorIndex = 4
                Else
                    ws.Cells(TickerCounter, 10).Interior.ColorIndex = 2
                End If
                
                ws.Cells(TickerCounter, 11).NumberFormat = "0.00%"
                
                TickerTotal = 0
                TickerCounter = TickerCounter + 1
                StartTicker = ws.Cells(row + 1, 3).Value
                ws.Columns("I:L").AutoFit
            Else
                TickerTotal = TickerTotal + ws.Cells(row, 7).Value
            End If
        Next row
        
        If ws.Range("P1").Value <> "Ticker" Then
            ws.Range("O1").EntireColumn.Insert
            ws.Range("P1").EntireColumn.Insert
            ws.Range("Q1").EntireColumn.Insert
            ws.Range("O2").Value = "Greatest % Increase"
            ws.Range("O3").Value = "Greatest % Decrease"
            ws.Range("Q2:Q3").NumberFormat = "0.00%"
            ws.Range("O4").Value = "Greatest Total Volume"
            ws.Range("P1").Value = "Ticker"
            ws.Range("Q1").Value = "Value"
        End If
        
        LastTickerRow = ws.Cells(Rows.Count, 12).End(xlUp).row
        MaxTotal = 0
        MaxDecrease = 0
        MaxIncrease = 0
        
        For row = 2 To LastTickerRow
            If ws.Cells(row, 11).Value > MaxIncrease Then
                MaxIncrease = ws.Cells(row, 11).Value
                MaxIncreaseName = ws.Cells(row, 9).Value
            ElseIf ws.Cells(row, 11).Value < MaxDecrease Then
                MaxDecrease = ws.Cells(row, 11).Value
                MaxDecreaseName = ws.Cells(row, 9).Value
            ElseIf ws.Cells(row, 12).Value > MaxTotal Then
                MaxTotal = ws.Cells(row, 12).Value
                MaxTotalName = ws.Cells(row, 9).Value
            End If
        Next row
        
        ws.Range("Q2").Value = MaxIncrease
        ws.Range("Q3").Value = MaxDecrease
        ws.Range("Q4").Value = MaxTotal
        ws.Range("P2").Value = MaxIncreaseName
        ws.Range("P3").Value = MaxDecreaseName
        ws.Range("P4").Value = MaxTotalName
        
        ws.Columns("O:Q").AutoFit
    Next ws
End Sub

