          SELECT DISTINCT soh.ShipmentOrderID
                                --,soh.CreatedBy AS OrderCreatedBy
                                            ,soh.CustomerCode
                                            ,soh.ShipmentOrderNo
                                            ,soh.PurchaseOrderReference
                                --            ,soh.ShipToName
                                            ,soh.OrderStatus
                                --            ,soh.ShipmentStage
                                --            ,soh.Commodity
                                --            ,soh.Comments
                                --            ,soh.PointOfFinalDelivery
                                --,soh.AvailableDateStart
                                --,soh.AvailableDateEnd
                                --,soh.CustomerETAStart
                                --,soh.CustomerETAEnd
                                --,soh.LastUpdated
                                --,soh.LastUpdatedBy
                                --            ,sol.FacilityName
                                --            ,sop.ReasonNotAssigned AttributeXML
                                            ,kcs.SettingValue AS CustomerReason
                                --,son.Notes as ExternalNotes
                                --,son.LastUpdated as ExternalNotesLastUpdated
                                --,son.LastUpdatedBy as ExternalNotesLastUpdatedBy
								
                            FROM Assignment_V3_0.dbo.shipmentorderpriority sop
                            JOIN Assignment_V3_0.dbo.ShipmentOrderHeader soh ON soh.ShipmentOrderID = sop.ShipmentOrderID --AND soh.OrderStatus IN ('New', 'Rework')
    

        JOIN Assignment_V3_0.dbo.ShipmentOrderLine sol ON sol.ShipmentOrderLineID = (
                                                     SELECT min(ShipmentOrderLineID)
                                                     FROM Assignment_V3_0.dbo.ShipmentOrderLine sol
                                                     WHERE sol.ShipmentOrderID = soh.ShipmentOrderID)
                     LEFT JOIN Assignment_V3_0.dbo.reasonnotassigned rna ON rna.ReasonNotAssignedID = sop.ReasonNotAssignedID
                     LEFT JOIN Rates_V3_0.dbo.KotahiCustomerSetting kcs ON kcs.CustomerCode = sop.CustomerCode
                                     AND kcs.SettingName = 'ReasonNotAssignedCoding'
                                     AND kcs.SettingSubName = (convert(NVARCHAR, sop.ReasonNotAssignedID) + '_TEXT')
                     left join Assignment_V3_0.dbo.ShipmentOrderNotes son on son.ShipmentOrderID = sop.ShipmentOrderID and son.NoteType = 'ExternalNote' and son.LastUpdated > convert(datetime, STUFF(STUFF(STUFF(substring(soh.CustomerVersion, 1, 14),9,0,' '),12,0,':'),15,0,':'))
                     -- WHERE sop.assignmentdate = (SELECT max(assignmentdate) FROM Assignment_V3_0.dbo.shipmentorderpriority) and sop.CustomerCode != 'FONTERRA'
				

					 inner join (
						select ShipmentOrderNo, max(AssignmentDate) as MaxDate
						from Assignment_V3_0.dbo.shipmentorderpriority
						group by ShipmentOrderNo
					 ) sop2 on sop.ShipmentOrderNo=sop2.ShipmentOrderNo and sop.AssignmentDate = sop2.MaxDate

					-- replace the number of sop.ShipmentOrderID when Custmer input ShipmentOrderID. 
					 where sop.ShipmentOrderID = '10613278'
					 
					 