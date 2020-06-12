@cds.persistence.exists
entity![SFLIGHT]{
    key![MANDT]      : String(3)               @title : 'MANDT';
    key![CARRID]     : String(3)               @title : 'CARRID';
    key![CONNID]     : String(4)               @title : 'CONNID';
    key![FLDATE]     : String(8)               @title : 'FLDATE';
       ![PRICE]      : Decimal(15, 2) not null @title : 'PRICE';
       ![CURRENCY]   : String(5) not null      @title : 'CURRENCY';
       ![PLANETYPE]  : String(10) not null     @title : 'PLANETYPE';
       ![SEATSMAX]   : Integer not null        @title : 'SEATSMAX';
       ![SEATSOCC]   : Integer not null        @title : 'SEATSOCC';
       ![PAYMENTSUM] : Decimal(17, 2) not null @title : 'PAYMENTSUM';
       ![SEATSMAX_B] : Integer not null        @title : 'SEATSMAX_B';
       ![SEATSOCC_B] : Integer not null        @title : 'SEATSOCC_B';
       ![SEATSMAX_F] : Integer not null        @title : 'SEATSMAX_F';
       ![SEATSOCC_F] : Integer not null        @title : 'SEATSOCC_F';
}

@cds.persistence.exists
entity![SBOOK]{
    key![MANDT]      : String(3)               @title : 'MANDT';
    key![CARRID]     : String(3)               @title : 'CARRID';
    key![CONNID]     : String(4)               @title : 'CONNID';
    key![FLDATE]     : String(8)               @title : 'FLDATE';
    key![BOOKID]     : String(8)               @title : 'BOOKID';
       ![CUSTOMID]   : String(8) not null      @title : 'CUSTOMID';
       ![CUSTTYPE]   : String(1) not null      @title : 'CUSTTYPE';
       ![SMOKER]     : String(1) not null      @title : 'SMOKER';
       ![LUGGWEIGHT] : Decimal(8, 4) not null  @title : 'LUGGWEIGHT';
       ![WUNIT]      : String(3) not null      @title : 'WUNIT';
       ![INVOICE]    : String(1) not null      @title : 'INVOICE';
       ![CLASS]      : String(1) not null      @title : 'CLASS';
       ![FORCURAM]   : Decimal(15, 2) not null @title : 'FORCURAM';
       ![FORCURKEY]  : String(5) not null      @title : 'FORCURKEY';
       ![LOCCURAM]   : Decimal(15, 2) not null @title : 'LOCCURAM';
       ![LOCCURKEY]  : String(5) not null      @title : 'LOCCURKEY';
       ![ORDER_DATE] : String(8) not null      @title : 'ORDER_DATE';
       ![COUNTER]    : String(8) not null      @title : 'COUNTER';
       ![AGENCYNUM]  : String(8) not null      @title : 'AGENCYNUM';
       ![CANCELLED]  : String(1) not null      @title : 'CANCELLED';
       ![RESERVED]   : String(1) not null      @title : 'RESERVED';
       ![PASSNAME]   : String(25) not null     @title : 'PASSNAME';
       ![PASSFORM]   : String(15) not null     @title : 'PASSFORM';
       ![PASSBIRTH]  : String(8) not null      @title : 'PASSBIRTH';
}

using SFLIGHT as FLIGHTTBL;
using SBOOK as BOOKINGS;

context FLIGHT {
    define view SflightView as
        select from FLIGHTTBL
        mixin {
            SBOOKLink : Association[ * ] to BOOKINGS
                            on  SBOOKLink.MANDT  = FLIGHTTBL.MANDT //$projection.Client
                            and SBOOKLink.CARRID = FLIGHTTBL.CARRID //$projection.CarrierId
                            and SBOOKLink.CONNID = FLIGHTTBL.CONNID //$projection.ConnectionId
                            and SBOOKLink.FLDATE = FLIGHTTBL.FLDATE; //$projection.FlightDate;
        }
        into {
            MANDT              as![Client],
            CARRID             as![CarrierId],
            CONNID             as![ConnectionId],
            FLDATE             as![FlightDate],
            PRICE              as![Price],
            CURRENCY           as![Currency],
            PLANETYPE          as![PlaneType],
            SBOOKLink.BOOKID   as![BookingId],
            SBOOKLink.CUSTOMID as![CustomerId],
            SBOOKLink.CUSTTYPE as![CustomerType],
            SBOOKLink.PASSNAME as![PassengerName]
        };

    @restrict : [{
        grant : 'READ',
        where : '$user.client = Client'
    }]
    define view SflightExt as
        select from SflightView {
            ![Client],
            ![CarrierId],
            ![ConnectionId],
            ![FlightDate],
            ![BookingId],
            ![Price],
            ![Currency],
            ![PlaneType],
            ![CustomerId],
            ![CustomerType],
            ![PassengerName]
        };

};
