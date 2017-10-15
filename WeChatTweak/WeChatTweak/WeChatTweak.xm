#import <objc/runtime.h>
#import <objc/message.h>

id redPacketParams = nil;
id logicMgr = nil;

static NSMutableArray *timingIdentifierArray = nil;

%hook CMessageMgr
- (void)AsyncOnAddMsg:(NSString *)msg MsgWrap:(id)wrap
{
    %log;
    %orig;
    if(timingIdentifierArray==nil) timingIdentifierArray = [[NSMutableArray alloc] init];
    id content = [wrap performSelector:@selector(m_nsContent)];
    int type = ((int (*)(id, SEL))objc_msgSend)(wrap,@selector(m_uiMessageType));
    if(type!=49)return;
    if([content rangeOfString:@"wxpay://"].location == NSNotFound) return;
    id nativeUrl = [[wrap  performSelector:@selector(m_oWCPayInfoItem)] performSelector:@selector(m_c2cNativeUrl)];
    id paramsUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
    NSDictionary *params = [%c(WCBizUtil) performSelector:@selector(dictionaryWithDecodedComponets:separator:) withObject:paramsUrl withObject:@"&"];
    id agreeDuty = @"0";
    id channelId = @"1";
    id inWay =     @"0";
    id url = nativeUrl;
    id sendId = params[@"sendid"];
    NSMutableDictionary *requestParams = [@{} mutableCopy];
    [requestParams setValue:sendId forKey:@"sendId"];
    [requestParams setValue:agreeDuty forKey:@"agreeDuty"];
    [requestParams setValue:channelId forKey:@"channelId"];
    [requestParams setValue:inWay forKey:@"inWay"];
    [requestParams setValue:url forKey:@"nativeUrl"];
    [requestParams setValue:@"1" forKey:@"msgType"];
    
    id serviceCenter = [%c(MMServiceCenter) performSelector:@selector(defaultCenter)];
    logicMgr =[serviceCenter performSelector:@selector(getService:) withObject:%c(WCRedEnvelopesLogicMgr)];
    [logicMgr performSelector:@selector(ReceiverQueryRedEnvelopesRequest:) withObject:requestParams];
    redPacketParams = requestParams;

    id contactManager = [[%c(MMServiceCenter) performSelector:@selector(defaultCenter)] performSelector:@selector(getService:) withObject:%c(CContactMgr)];
    id selfContact = [contactManager performSelector:@selector(getSelfContact)];
    id sessionUserName = [wrap performSelector:@selector(m_nsFromUsr)];
    id headImg = [selfContact performSelector:@selector(m_nsHeadImgUrl)];
    id nickName = [selfContact performSelector:@selector(getContactDisplayName)];
    [redPacketParams setValue:sessionUserName forKey:@"sessionUserName"];
    [redPacketParams setValue:headImg forKey:@"headImg"];
    [redPacketParams setValue:nickName forKey:@"nickName"];
}

%end


%hook WCRedEnvelopesLogicMgr

- (void)OnWCToHongbaoCommonResponse:(id)arg1 Request:(id)arg2
{
    %log;
    %orig;
    id reponseString = [[NSString alloc] initWithData:[[arg1 performSelector:@selector(retText)] performSelector:@selector(buffer)] encoding:NSUTF8StringEncoding];
    NSDictionary *reponse =  [reponseString performSelector:@selector(JSONDictionary)];
    id timingIdentifier = reponse[@"timingIdentifier"];
    if (timingIdentifier&&![timingIdentifierArray containsObject:timingIdentifier]) {
        [redPacketParams setValue:timingIdentifier forKey:@"timingIdentifier"];
        [logicMgr performSelector:@selector(OpenRedEnvelopesRequest:) withObject:redPacketParams];
        [timingIdentifierArray addObject:timingIdentifier];
    }
}
%end
