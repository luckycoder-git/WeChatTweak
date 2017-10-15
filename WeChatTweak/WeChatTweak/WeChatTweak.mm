#line 1 "/Users/shang/Desktop/jianshu/WeChatTweak_git/WeChatTweak/WeChatTweak.xm"
#import <objc/runtime.h>
#import <objc/message.h>

id redPacketParams = nil;
id logicMgr = nil;

static NSMutableArray *timingIdentifierArray = nil;


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class WCBizUtil; @class MMServiceCenter; @class WCRedEnvelopesLogicMgr; @class CMessageMgr; @class CContactMgr; 
static void (*_logos_orig$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$)(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, NSString *, id); static void _logos_method$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, NSString *, id); static void (*_logos_orig$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$)(_LOGOS_SELF_TYPE_NORMAL WCRedEnvelopesLogicMgr* _LOGOS_SELF_CONST, SEL, id, id); static void _logos_method$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$(_LOGOS_SELF_TYPE_NORMAL WCRedEnvelopesLogicMgr* _LOGOS_SELF_CONST, SEL, id, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$CContactMgr(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("CContactMgr"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$WCBizUtil(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("WCBizUtil"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$MMServiceCenter(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("MMServiceCenter"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$WCRedEnvelopesLogicMgr(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("WCRedEnvelopesLogicMgr"); } return _klass; }
#line 9 "/Users/shang/Desktop/jianshu/WeChatTweak_git/WeChatTweak/WeChatTweak.xm"


static void _logos_method$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * msg, id wrap) {
    _logos_orig$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$(self, _cmd, msg, wrap);
    if(timingIdentifierArray==nil) timingIdentifierArray = [[NSMutableArray alloc] init];
    id content  =    [wrap performSelector:@selector(m_nsContent)];
    int type = ((int (*)(id, SEL))objc_msgSend)(wrap,@selector(m_uiMessageType));
    if(type!=49)return;
    if([content rangeOfString:@"wxpay://"].location == NSNotFound) return;
    id nativeUrl = [[wrap  performSelector:@selector(m_oWCPayInfoItem)] performSelector:@selector(m_c2cNativeUrl)];
    id paramsUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
    NSDictionary *params = [_logos_static_class_lookup$WCBizUtil() performSelector:@selector(dictionaryWithDecodedComponets:separator:) withObject:paramsUrl withObject:@"&"];
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
    
    id serviceCenter = [_logos_static_class_lookup$MMServiceCenter() performSelector:@selector(defaultCenter)];
    logicMgr =[serviceCenter performSelector:@selector(getService:) withObject:_logos_static_class_lookup$WCRedEnvelopesLogicMgr()];
    [logicMgr performSelector:@selector(ReceiverQueryRedEnvelopesRequest:) withObject:requestParams];
    redPacketParams = requestParams;

    id contactManager = [[_logos_static_class_lookup$MMServiceCenter() performSelector:@selector(defaultCenter)] performSelector:@selector(getService:) withObject:_logos_static_class_lookup$CContactMgr()];
    id selfContact = [contactManager performSelector:@selector(getSelfContact)];
    id sessionUserName = [wrap performSelector:@selector(m_nsFromUsr)];
    id headImg = [selfContact performSelector:@selector(m_nsHeadImgUrl)];
    id nickName = [selfContact performSelector:@selector(getContactDisplayName)];
    [redPacketParams setValue:sessionUserName forKey:@"sessionUserName"];
    [redPacketParams setValue:headImg forKey:@"headImg"];
    [redPacketParams setValue:nickName forKey:@"nickName"];
}








static void _logos_method$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$(_LOGOS_SELF_TYPE_NORMAL WCRedEnvelopesLogicMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2) {
    HBLogDebug(@"-[<WCRedEnvelopesLogicMgr: %p> OnWCToHongbaoCommonResponse:%@ Request:%@]", self, arg1, arg2);
    _logos_orig$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$(self, _cmd, arg1, arg2);
    id reponseString = [[NSString alloc] initWithData:[[arg1 performSelector:@selector(retText)] performSelector:@selector(buffer)] encoding:NSUTF8StringEncoding];
    NSDictionary *reponse =  [reponseString performSelector:@selector(JSONDictionary)];
    id timingIdentifier = reponse[@"timingIdentifier"];
    if (timingIdentifier&&![timingIdentifierArray containsObject:timingIdentifier]) {
        [redPacketParams setValue:timingIdentifier forKey:@"timingIdentifier"];
        [logicMgr performSelector:@selector(OpenRedEnvelopesRequest:) withObject:redPacketParams];
        [timingIdentifierArray addObject:timingIdentifier];
        }
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$CMessageMgr = objc_getClass("CMessageMgr"); MSHookMessageEx(_logos_class$_ungrouped$CMessageMgr, @selector(AsyncOnAddMsg:MsgWrap:), (IMP)&_logos_method$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$, (IMP*)&_logos_orig$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$);Class _logos_class$_ungrouped$WCRedEnvelopesLogicMgr = objc_getClass("WCRedEnvelopesLogicMgr"); MSHookMessageEx(_logos_class$_ungrouped$WCRedEnvelopesLogicMgr, @selector(OnWCToHongbaoCommonResponse:Request:), (IMP)&_logos_method$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$, (IMP*)&_logos_orig$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$);} }
#line 69 "/Users/shang/Desktop/jianshu/WeChatTweak_git/WeChatTweak/WeChatTweak.xm"
